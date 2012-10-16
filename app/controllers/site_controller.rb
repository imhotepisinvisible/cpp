class SiteController < ApplicationController
  def index
    # No Variables/Code Necessary Right now
  end

  def sample_student_dashboard
    # No Variables/Code Necessary Right now
  end

  def sample_student_companies

  end

  def sample_student_company

  end

  def sample_company_dashboard

  end

  def sample_company_students

  end

  def sample_company_student

  end

  def sample_admin_students
    @people = ["Peter Hamilton",
               "Tom Wilshere",
               "Jack Stevenson",
               "Tom Wilding",
               "Sarah Tattersall"]
    @years = ["First Year", "Second Year"]
  end

  def sample_admin_companies

  end

  def sample_admin_placements

  end

  def sample_admin_emails
    
  end

  def sample_admin_stats
    data_table = GoogleVisualr::DataTable.new
    # Add Column Headers
    data_table.new_column('string', 'Year' )
    data_table.new_column('number', 'Views')
    data_table.new_column('number', 'Emails')

    # Add Rows and Values
    data_table.add_rows([
      ['2004', 1000, 400],
      ['2005', 1170, 460],
      ['2006', 660, 1120],
      ['2007', 1030, 540]
    ])

    option = { title: 'Company Performance' }
    @linechart = GoogleVisualr::Interactive::AreaChart.new(data_table, option)
    @piechart = GoogleVisualr::Interactive::PieChart.new(data_table, option)
    @barchart = GoogleVisualr::Interactive::BarChart.new(data_table, option)


    data_table2 = GoogleVisualr::DataTable.new
    data_table2.new_column('date'  , 'Date')
    data_table2.new_column('number', 'Sold Pencils')
    data_table2.new_column('string', 'title1')
    data_table2.new_column('string', 'text1' )
    data_table2.new_column('number', 'Sold Pens'   )
    data_table2.new_column('string', 'title2')
    data_table2.new_column('string', 'text2' )
    data_table2.add_rows( [
      [ Date.parse("2008-2-1"), 30000, '', '', 40645, '', ''],
      [ Date.parse("2008-2-2"), 14045, '', '', 20374, '', ''],
      [ Date.parse("2008-2-3"), 55022, '', '', 50766, '', ''],
      [ Date.parse("2008-2-4"), 75284, '', '', 14334, 'Out of Stock','Ran out of stock on pens at 4pm'],
      [ Date.parse("2008-2-5"), 41476, 'Bought Pens','Bought 200k pens', 66467, '', ''],
      [ Date.parse("2008-2-6"), 33322, '', '', 39463, '', '']
    ] )

    opts   = { :displayAnnotations => true }
    @timechart = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table2, opts)

  end

end
