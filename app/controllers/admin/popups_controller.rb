class Admin::PopupsController < AdminController
  set_tab :popups
  before_filter :find_popup, :only => [:show, :edit, :update, :destroy]
  
  def index
    @popups = Popup.all
  end

  def show
  end

  def new
    @popup = Popup.new
  end

  def edit
  end

  def create
    @popup = Popup.new(params[:popup])
    if @popup.save
      redirect_to(admin_popup_path(@popup), :notice => 'Popup was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @popup.update_attributes(params[:popup])
      redirect_to(admin_popup_path(@popup), :notice => 'Popup was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @popup.destroy
    redirect_to(admin_popups_path, :notice => 'Popup deleted')
  end
  
  private
  
    def find_popup
      @popup = Popup.find(params[:id])
    end
end
