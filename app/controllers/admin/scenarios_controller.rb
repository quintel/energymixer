class Admin::ScenariosController < AdminController
  before_filter :find_scenario, :except => [:index, :analysis, :new, :create, :stats]

  def index
    @scenarios = Scenario.recent_first.page(params[:page]).per(30)
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

  def stats
    @rows = ActiveRecord::Base.connection.select_all("SELECT count(id) AS c, YEAR(created_at) AS y, MONTH(created_at) AS m FROM scenarios GROUP BY y, m")
  end

  def analysis
    @scenarios = Scenario.order(params[:sort]).find(params[:id])
    @question_set = @scenarios.first.question_set
    if(params[:sort_data])
      data = params[:sort_data].split(" ")
      if(Scenario.method_defined?(data[0]))
        if(data[1] == "asc")
          @scenarios.sort! { |a,b| a.send(data[0]) <=> b.send(data[0])  }
        else
          @scenarios.sort! { |a,b| b.send(data[0]) <=> a.send(data[0])  }
        end
      end
    end
  end


  protected
  def find_scenario
    @scenario = Scenario.find(params[:id])
  end
end
