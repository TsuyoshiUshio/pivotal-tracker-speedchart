# -*- coding: utf-8 -*-

require 'pivotal-tracker'
require 'yaml'

module Pivotal
  module Tracker
    # Mapping to the outer resource
    # This version only for Pivotal Tracker
    # @author Tsuyoshi Ushio
    module  Mapper
      def self.append_features(base)
        begin
          config = YAML.load_file('.speedchart')
        rescue
          puts "Please create config file '.speedchart'"
          exit -1
        end
        PivotalTracker::Client.token = config['token']
        @@project = PivotalTracker::Project.find(config['project_id'])
        super
      end

      # get stories on the BackLog
      # @return [Array<PivotalTracker::Story>] stories on the backlog
      def current_stories
        # typeがfeatureかつ、unscheduled以外
        @@project.stories.all.select{|x| (x.story_type == "feature") && (x.current_state != "unscheduled")}
      end

      # get stories depend on the state
      # @param [String] state of story (unstarted/finished/delivered/accepted)
      # @return [Array<PivotalTracker::Story>] stories on the backlog selected by state
      def find_by_state_stories(state)
        current_stories.select{|x| x.current_state == state}
      end

      # 日付以前に作成されたすべてのストーリを返却する
      # @param date [Date] 日付
      # @param stories [PivotalTracker::Story] ストーリの配列
      # @return 日付以前に作成されたすべてのストーリ
      def total_stories(date, stories)
        stories.select{|story| story.created_at.to_date <= date}
      end

      # 日付以前にAcceptされたすべてのストーリを返却する
      # @param date [Date] 日付
      # @param stories [PivotalTracker::Story] ストーリの配列
      # @return 日付以前にAcceptされたすべてのストーリ
      def accepted_stories(date, stories)
        stories.select{|story| (!story.accepted_at.nil? && story.accepted_at.to_date <= date)}
      end

      # ある特定の日付の、ストーリのサイズを返却する
      # @param date [Date] 日付
      # @param stories [PivotalTracker::Story] ストーリの配列
      # @return ある特定の日付の、[総ストーリ数、Acceptedストーリ数, 残りストーリ数] の配列
      def aggrigate_story_size_by_date(date, stories)
        total_size = total_stories(date, stories).size
        accepted_size =  accepted_stories(date, stories).size
        [total_size, accepted_size, total_size - accepted_size]
      end

      # 過去にさかのぼった、ストーリ総数と、Accepted数、todoストーリ数を返却する
      # @param year [Integer] 開始年
      # @param month [Integer] 開始月
      # @param date [Integer] 開始日
      # @return [日付, 総ストーリ数, Acceptedストーリ数, 残りストーリ数]の配列
      def summrize_stories(year, month, date)
        stories = current_stories
        story_summaries = Array.new
        (Date.new(year, month, date).. Date.today).each{|current_date|
          story_summaries << [current_date , aggrigate_story_size_by_date(current_date, stories)].flatten
        }
        story_summaries
      end

      module_function :summrize_stories
      module_function :current_stories
    end
  end
end
