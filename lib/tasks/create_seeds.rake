namespace :db do
  task create_seeds: :environment do
    def seedify(model, dir)
      content = YAML.dump(model.all.map(&:attributes))
      File.write(dir.join("#{ model.name.tableize }.yml"), content)
    end

    # --

    seeds_dir = Rails.root.join('db/seeds')

    if seeds_dir.directory?
      seeds_dir.children(&:delete)
    else
      FileUtils.mkdir_p(seeds_dir)
    end

    seedify(Answer, seeds_dir)
    seedify(AnswerConflict, seeds_dir)
    seedify(DashboardItem, seeds_dir)
    seedify(Input, seeds_dir)
    seedify(Popup, seeds_dir)
    seedify(Question, seeds_dir)
    seedify(QuestionSet, seeds_dir)
    seedify(Translation, seeds_dir)
  end # :create_seeds
end # :db
