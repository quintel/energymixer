module AdminHelper
  # @return [String]
  #   Creates a select field so that the user can swap to a different
  #   partition.
  #
  def partition_select_tag
    sets = QuestionSet.order('`name` ASC').map do |set|
      [ set.name, Partition.named(set.name).host ]
    end

    select_tag('partition', options_from_collection_for_select(
      sets, :second, :first, partition.host))
  end
end
