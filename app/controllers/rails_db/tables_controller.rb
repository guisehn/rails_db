module RailsDb
  class TablesController < RailsDb::ApplicationController

    def index
      @tables = ActiveRecord::Base.connection.tables.sort
    end

    def show
      @table = RailsDb::Table.new(params[:id])
    end

    def data
      @table   = RailsDb::Table.new(params[:table_id]).paginate :page => params[:page],
                                                                :sort_column => params[:sort_column],
                                                                :sort_order => params[:sort_order],
                                                                :per_page => params[:per_page]
    end

    def csv
      @table = RailsDb::Table.new(params[:table_id])
      send_data(@table.to_csv, :type => 'text/csv; charset=utf-8; header=present', :filename => "#{@table.name}.csv")
    end


  end
end