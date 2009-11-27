require 'rubygems'
require 'httparty'

class WebTrends
  include HTTParty

  APIVERSION = 'v1'
  
  default_params :dcsformat => 'xml'
  format :xml
  base_uri "http://dc.webtrends.com/#{APIVERSION}"
  
  def initialize(options={})
    @dcsid   = options[:dcsid] || "dcslbiart00000gwngvpqkrcn_2u3z"
    @verbose = options[:verbose] || false
  end


  #Methods for the Data Collection API
  def get_visitor_identifier
    self.class.post("/#{@dcsid}/ids.svc", :body=>extra_params)['id']
  end

  def post_event(visitor_id, event={})
    body = {
      :dcsuri    => '/MyRubyTest',
      :dcssip    => 'localhost',
      :'WT.ti'   => 'My Ruby Test',
      :'WT.co_f' => visitor_id
    }.merge(extra_params).merge(event)
    self.class.post("/#{@dcsid}/events.svc", :body=>body)
  end
  
  #Methods for the Data Extraction API

  # Optional params
  # format
  #     # JSON (default), Excel, or XML 
  # period
  #     # Time period of interest, expressed as year, month, day or trend length required) 
  # start period
  #     # The beginning time period of a custom date range (not compatible with trending) 
  # end period
  #     # The ending time period of a custom date range (not compatible with trending) 
  # measures
  #     # Measures to return
  # search
  #     # String within a dimension name; returns only rows containing that string 
  # range
  #     # Number of rows to return 
  # totalsonly
  #     # Set to true to return totals only (useful for populating dashboards) 
  # suppress error codes
  #     # Set to true if you don't want the service to return error codes

  def list_profiles
    # /profiles returns a list of profiles.
  end
  def profile_summary(profile_id)
    # /profiles/{profile ID} returns summary data for a profile, including the last time the profile was analyzed, so client applications can determine when to refresh data. The interval between updates is at least 15 minutes.
  end
  def list_reports_for_profile(profile_id)
    # /profiles/{Profile ID}/reports lists the reports defined for a profile.
  end
  def get_report_definition(profile_id, report_id)
    # /profiles/{Profile ID}/reports/{Report ID}/info returns the report definition for the given report ID.
  end
  def list_report_time_periods(profile_id)
    # profiles/{Profile ID}/periods returns the time periods for a given report.
  end
  def get_report_data_for_period(profile_id, report_id, period)
    # /profiles/{Profile ID}/reports/{Report ID}/?period={Period} returns the report data for a given period.
  end
  def list_templates(profile_id)
    # /profiles/{Profile ID}/templates/ returns a list of the template definitions (and their report definitions) that are associated with the specified profile.
  end
  def get_template_definition(profile_id, template_id)
    # /profiles/{Profile ID}/templates/{Template ID} returns the definition of the specified template and its associated report definitions.
  end

  
private 

  def self.verbose?
    @verbose
  end

  def extra_params
    @verbose ? {:dcsverbose=>true} : {}
  end

end

client = WebTrends.new(:verbose=>true)
puts "* Getting visitor ID..."
visitor_id = client.get_visitor_identifier.inspect
puts "* Visitor ID=#{visitor_id}"
puts "* Posting event"
puts client.post_event(visitor_id).inspect
