class Admin::ScenariosController < AdminController
  set_tab :scenarios  
  before_filter :find_scenario, :except => [:index, :new, :create]

  def index
    @scenarios = Scenario.recent_first.page(params[:page])
  end

  def show
  end

  def new
    @scenario = Scenario.new
  end

  def edit
  end

  def create
    @scenario = Scenario.new(params[:scenario])

    if @scenario.save
      redirect_to(admin_scenario_path(@scenario), :notice => 'Scenario was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @scenario.update_attributes(params[:scenario])
      redirect_to(admin_scenario_path(@scenario), :notice => 'Scenario was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @scenario.destroy
    redirect_to(admin_scenarios_url, :notice => 'Scenario deleted')
  end

  protected

  def find_scenario
    @scenario = Scenario.find(params[:id])
  end
end
