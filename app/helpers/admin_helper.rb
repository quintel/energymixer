module AdminHelper
  # @return [String]
  #   Creates a select field so that the user can swap to a different
  #   partition.
  #
  def partition_select_tag
    select_tag('partition', options_from_collection_for_select(
      QuestionSet.order('`name` ASC'), :name, :name, partition.name))
  end
end
