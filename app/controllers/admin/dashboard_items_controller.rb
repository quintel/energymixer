class Admin::DashboardItemsController < AdminController
  before_filter :find_dashboard_item, :except => [:index, :new, :create]
  
  def index
    @dashboard_items = @question_set.dashboard_items.ordered.all
  end

  def show
  end

  def new
    @dashboard_item = DashboardItem.new
  end

  def edit
  end

  def create
    @dashboard_item = @question_set.dashboard_items.build(params[:dashboard_item])

    if @dashboard_item.save
      redirect_to(admin_dashboard_item_path(@dashboard_item), :notice => 'Dashboard Item was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @dashboard_item.update_attributes(params[:dashboard_item])
      redirect_to(admin_dashboard_item_path(@dashboard_item), :notice => 'Dashboard Item was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @dashboard_item.destroy
    redirect_to(admin_dashboard_items_url, :notice => 'Dashboard Item deleted')
  end
  
  protected
  
    def find_dashboard_item
      @dashboard_item = @question_set.dashboard_items.find(params[:id])
    end
end
