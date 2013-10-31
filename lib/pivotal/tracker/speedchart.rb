# -*- coding: utf-8 -*-

require "pivotal/tracker/speedchart/version"
require "pivotal/tracker/excel_base"
require "pivotal/tracker/mapper"
require 'date'

module Pivotal
  module Tracker
    # Speed Chart Generator using Pivotal-Tracker
    # @author Tsuyoshi Ushio
    module Speedchart
      include Pivotal::Tracker::Mapper
      include ExcelBase
      include Spreadsheet

      # Creates project summary for speed chart
      # generates speed_chart.xls on current directory
      # @param to_date [Date] the last date of speed chart
      def create_excel_by_story_summary(to_date = Date.today)

        xls_file_name =  'speed_chart.xls'

        File.delete(xls_file_name) if File.exists?(xls_file_name)
        book = Spreadsheet::Workbook.new
        sheet = book.create_worksheet_with_name Date.today.to_s
        sheet.row(0).make_title ["Date", "total", "accepted", "todo"]
        summrize_stories(project_started_at, to_date).each_with_index do |story_summary, i|
          sheet.row(i+1).add_data story_summary
        end
        book.write xls_file_name
      end

      # Generates speed_chart.xls on current directory
      # From the first date of the project to today.
      def create_speed_chart
        create_excel_by_story_summary
      end

      # Generates speed_chart.xls on current directory
      # Compare with create_speed_chart, you can specify the last day of the speed chart
      # @param to_date [Date] last date of the speed chart
      def create_speed_chart_with_to_date(to_date)
        create_excel_by_story_summary(to_date)
      end

      require 'gruff'

      def create_speed_chart_with_png_to_date(to_date = Date.today)
        g = Gruff::Line.new(4096)
        g.title = "Speed Chart " + Date.today.to_s
        #g.labels = {0 => '2013/10/11', 50 => '2013/11/30', 100 => '2013/2/10'}

        stories = summrize_stories(project_started_at, to_date)

        #g.labels = Hash[*stories.map{|x| x[0]}.each_with_index.map{|x,i| [i, x.strftime("%d/%m/%Y")]}.flatten]
        g.labels = {0 => project_started_at.strftime("%d/%m/%Y"),
                    (stories.size / 2).round => (project_started_at + ((to_date - project_started_at)/2).round).strftime("%d/%m/%Y"),
                    (stories.size - 31) => 'a'} # to_date.strftime("%d/%m/%Y")}
        # プロットのあるところにしか、labelは表示されないご様子
        puts g.labels.to_s
        g.data :Total, stories.map{|x| x[1]}
        g.data :Accepted, stories.map{|x| x[2]}
        g.data :ToDo, stories.map{|x| x[3]}
        g.dot_radius = 1

        g.write('speedchart.png')


      end

      # Shows all story detail on the backlog
      #
      def current_story_dump
        current_stories.each{|story|
          puts story.story_type + ":" + story.name + ":" + story.current_state + ":" + story.created_at.to_s + ":" + story.created_at.class.to_s + ":" + story.accepted_at.to_s  + ":" + story.url
        }
      end

      # Current project status of today.
      def story_state_of_today
        puts "-------------------------"
        puts "Project Status"
        puts Time.now.to_s
        puts "-------------------------"
        puts "total       :"+current_stories.size.to_s
        puts "unstareted  :"+find_by_state_stories("unstarted").size.to_s
        puts "started     :"+find_by_state_stories("started").size.to_s
        puts "finished    :"+find_by_state_stories("finished").size.to_s
        puts "delivered   :"+find_by_state_stories("delivered").size.to_s
        puts "accepted    :"+find_by_state_stories("accepted").size.to_s
        puts "-------------------------"
      end

      # Message of generation
      def create_message_of_speed_chart
        puts "-------------------------"
        puts "Speed Chart Generator ver1.0 "
        puts "'speed_chart.xls' was successfully generated."
        puts "Lets create speedchart using line graph!"
        puts ""
      end

    end
  end
end
