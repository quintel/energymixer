module AdminHelper
  # @return [String]
  #   Creates a select field so that the user can swap to a different
  #   partition.
  #
  def partition_select_tag
    sets = QuestionSet.order('`name` ASC').map do |set|
      begin
        [ set.name, Partition.named(set.name).host ]
      rescue Partition::NoSuchPartition
        # Ignore question sets which have no partition.
      end
    end.compact

    select_tag('partition', options_from_collection_for_select(
      sets, :second, :first, partition.host))
  end

  # @return [String]
  #   Front page and admin links for a question set.
  #
  def question_set_host_links(set)
    host = Partition.named(set.name).host

    [ link_to('Front page', "http://#{ host }"),
      link_to('Admin page', "http://#{ host }/admin")
    ].join(' &ndash; ').html_safe

  rescue Partition::NoSuchPartition
    <<-HTML.html_safe
      <span style="color:#777">
        No partition config - please add it to config.yml.
      </span>
    HTML
  end
end
