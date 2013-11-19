class Admin::ScenariosController < AdminController
  before_filter :find_scenario, :except => [:index, :analysis, :new, :create, :stats]

  def index
    @scenarios = question_set.scenarios.recent_first.page(params[:page]).per(200)
  end

  def show
  end

  def new
    @scenario = Scenario.new
  end

  def edit
  end

  def create
    @scenario = question_set.scenarios.build(params[:scenario])
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
    set_id = ActiveRecord::Base.sanitize(question_set.id)

    @rows = ActiveRecord::Base.connection.select_all <<-SQL
      SELECT
          count(id)         AS c,
          YEAR(created_at)  AS y,
          MONTH(created_at) AS m
      FROM
          scenarios
      WHERE
          scenarios.question_set_id = #{ set_id }
      GROUP BY
          y, m
    SQL
  end

  def analysis
    @scenarios = Scenario.order(params[:sort]).find(params[:id])
    question_set = @scenarios.first.question_set
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
    @scenario = question_set.scenarios.find(params[:id])
  end
end
