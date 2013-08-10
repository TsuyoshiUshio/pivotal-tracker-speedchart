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

      # Excelにストーリのサマリを作成する（スピードチャートの作成）
      # 現状では、artifactディレクトリの下のspeed_chart.xlsが出来るようになっている
      # @param year [Integer] 作成開始年
      # @param month [Integer] 開始月
      # @param date [Integer] 開始日
      def create_excel_by_story_summary(year, month, date)

        xls_file_name =  'speed_chart.xls'

        File.delete(xls_file_name) if File.exists?(xls_file_name)
        book = Spreadsheet::Workbook.new
        sheet = book.create_worksheet_with_name Date.today.to_s
        sheet.row(0).make_title ["Date", "total", "accepted", "todo"]
        summrize_stories(year, month, date).each_with_index do |story_summary, i|
          sheet.row(i+1).add_data story_summary
        end
        book.write xls_file_name
      end

      # スピードチャートの作成
      # 現状では、artifactディレクトリの下のspeed_chart.xlsが出来るようになっている
      # PivotalTrackerに登録された最初の日付から、現在までのチャートが作られる。
      # プロジェクト毎に開始日時を設定してください。
      def create_speed_chart
        create_excel_by_story_summary(2013, 6, 1)
      end

      # Excelにスピードチャートを作成する
      # 指定した日付から始まり、現在日までのデータが作成される
      # 現状では、artifactディレクトリの下のspeed_chart.xlsが出来るようになっている
      # @param year [Integer] 作成開始年
      # @param month [Integer] 開始月
      # @param date [Integer] 開始日
      def create_speed_chart_with_date(year, month, date)
        create_excel_by_story_summary(year, month, date)
      end


      # 現在のストーリのダンプを表示する
      # ストーリの詳細が見れる
      def current_story_dump
        current_stories.each{|story|
          puts story.story_type + ":" + story.name + ":" + story.current_state + ":" + story.created_at.to_s + ":" + story.created_at.class.to_s + ":" + story.accepted_at.to_s  + ":" + story.url
        }
      end

      # 本日のストーリ状況の表示
      def story_state_of_today
        puts "---------------------"
        puts "本日のストーリ状況"
        puts Time.now.to_s
        puts "---------------------"
        puts "total       :"+current_stories.size.to_s
        puts "unstareted  :"+find_by_state_stories("unstarted").size.to_s
        puts "started     :"+find_by_state_stories("started").size.to_s
        puts "finished    :"+find_by_state_stories("finished").size.to_s
        puts "delivered   :"+find_by_state_stories("delivered").size.to_s
        puts "accepted    :"+find_by_state_stories("accepted").size.to_s
        puts "---------------------"
      end

      # Speed Chart生成メッセージ
      def create_message_of_speed_chart
        puts "---------------------"
        puts " Speed Chart Generator ver1.0 "
        puts "Speed Chartが artifcats/speed_chart.xlsに作成されました"
        puts "折れ線グラフを使ってプロジェクトの状況を見てみましょう"
        puts ""
      end

    end
  end
end
