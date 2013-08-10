#  Excel Base Module
#

module Pivotal
  module Tracker
    module ExcelBase
      require 'rubygems'
      require 'spreadsheet'

      Spreadsheet.client_encoding = 'UTF-8'

      class NormalFormat < Spreadsheet::Format
        def initialize(opts={})
          super opts.merge(:size => 11)
        end
      end

      class TitleFormat < NormalFormat
        def initialize
          super :color => :red, :weight => :bold, :horizontal_align => :center
        end
      end

      class ColorFormat < NormalFormat
        def initialize(color)
          super :pattern => 1, :pattern_fg_color => color
        end
      end
    end

    module Spreadsheet
      class Workbook
        def create_worksheet_with_name(name)
          sheet = create_worksheet(:name => name)
          sheet.default_format = ExcelBase::NormalFormat.new
          return sheet
        end
      end

      class Row
        def make_title(title_array)
          concat title_array
          self.default_format = ExcelBase::TitleFormat.new
          self.height = 14
        end

        def add_data(data_array)
          concat data_array
          self.height = 14
        end
      end
    end
  end
end
