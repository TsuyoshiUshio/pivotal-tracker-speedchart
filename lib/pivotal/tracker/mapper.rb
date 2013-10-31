# -*- coding: utf-8 -*-

require 'pivotal-tracker'
require 'yaml'

module Pivotal
  module Tracker
    # Mapper of outer resource
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

        begin
          PivotalTracker::Client.token = config['token']
          @@project = PivotalTracker::Project.find(config['project_id'])
        rescue RestClient::Unauthorized
          puts "Wrong token. please check out .speedchart"
          exit -1
        rescue RestClient::ResourceNotFound
          puts "Wrong project_id. please check out .speedchart"
          exit -1
        end

          @@project_started_at = config['started_at']

          unless @@project_started_at.class == Date
           puts "Wrong started_at. please check out .speedchart"
           exit -1
          end

        super
      end

      def project_started_at
        @@project_started_at
      end

      # Returns stories on the BackLog
      # @return [Array<PivotalTracker::Story>] stories on the backlog
      def current_stories
        # type = feature and not unscheduled
        @@project.stories.all.select{|x| (x.story_type == "feature") && (x.current_state != "unscheduled")}
      end

      # Return stories match the state
      # @param [String] state of story (unstarted/finished/delivered/accepted)
      # @return [Array<PivotalTracker::Story>] stories on the backlog selected by state
      def find_by_state_stories(state)
        current_stories.select{|x| x.current_state == state}
      end

      # Returns all stories created before the date
      # @param date [Date] the date
      # @param stories [PivotalTracker::Story] Stories
      # @return [Array<PivotalTracker::Story>] stories created befor the date
      def total_stories(date, stories)
        stories.select{|story| story.created_at.to_date <= date}
      end

      # Returns all stories accepted and created before the date
      # @param date [Date] the date
      # @param stories [PivotalTracker::Story] Stories
      # @return [Array<PivotalTracker::Story>] stories accepted and created before the date
      def accepted_stories(date, stories)
        stories.select{|story| (!story.accepted_at.nil? && story.accepted_at.to_date <= date)}
      end

      # Returns the report of the story sizes.
      # @param date [Date] the date
      # @param stories [PivotalTracker::Story] Stories
      # @return [Array<Integer,Integer,Integer,Integer>] [Total, Accepted, Todo]
      def aggrigate_story_size_by_date(date, stories)
        total_size = total_stories(date, stories).size
        accepted_size =  accepted_stories(date, stories).size
        [total_size, accepted_size, total_size - accepted_size]
      end

      # Returns All Story Num, Accepted Num and Todo Num
      # @param from_date [Date] the first date of speed chart
      # @param to_date [Date] the last date of speed chart
      # @return [Array<Date, Integer, Integer,Integer>] [Date, Total, Accepted, Todo]
      def summrize_stories(from_date, to_date = Date.today)
        stories = current_stories
        story_summaries = Array.new
        (from_date .. to_date).each{|current_date|
          if (current_date <= Date.today) then
            story_summaries << [current_date , aggrigate_story_size_by_date(current_date, stories)].flatten
          else
            story_summaries << [current_date , [nil, nil, nil]]
          end
        }
        story_summaries
      end
      module_function :project_started_at
      module_function :summrize_stories
      module_function :current_stories
    end
  end
end
