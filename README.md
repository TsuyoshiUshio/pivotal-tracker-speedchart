# Pivotal::Tracker::Speedchart

TODO: Now under construction

## Installation

Add this line to your application's Gemfile:

    gem 'pivotal-tracker-speedchart'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pivotal-tracker-speedchart

## Usage

  create .speedchart file

    token :  'pivotal tracker api-token of you'
    project_id : project_id of your project in pivotal tracker
    started_at : when project was stated (It is used for started date of speed chart data)

  example

    token : '51423c566101d5....'
    project_id : 871...
    started_at : 2013-06-01

  then type this

    $ speedchart

or If you want to specify the started date, use this.

    $ speedchart 20130610


  You can get speed_chart.xls. Please create speed chart using excel graph functions!


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Reference

I use this guy's code about spreadsheet(exce_base.rb). Thank you!

http://blog.livedoor.jp/sasata299/archives/51351663.html
