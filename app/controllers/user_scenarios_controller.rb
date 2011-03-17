class UserScenariosController < AdminController
  before_filter :find_user_scenario, :except => [:index, :new, :create]

  def index
    @user_scenarios = UserScenario.recent_first.page(params[:page])
  end

  def show
  end

  def new
    @user_scenario = UserScenario.new
  end

  def edit
  end

  def create
    @user_scenario = UserScenario.new(params[:user_scenario])

    if @user_scenario.save
      redirect_to(@user_scenario, :notice => 'User Scenario was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    if @user_scenario.update_attributes(params[:user_scenario])
      redirect_to(@user_scenario, :notice => 'User Scenario was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @user_scenario.destroy
    redirect_to(user_scenarios_url, :notice => 'User Scenario deleted')
  end

  protected

  def find_user_scenario
    @user_scenario = UserScenario.find(params[:id])
  end
end
