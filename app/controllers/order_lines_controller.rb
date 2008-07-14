class OrderLinesController < ApplicationController
  # GET /order_lines
  # GET /order_lines.xml
  def index
    @order_lines = OrderLine.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @order_lines }
    end
  end

  # GET /order_lines/1
  # GET /order_lines/1.xml
  def show
    @order_line = OrderLine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order_line }
    end
  end

  # GET /order_lines/new
  # GET /order_lines/new.xml
  def new
    @order_line = OrderLine.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order_line }
    end
  end

  # GET /order_lines/1/edit
  def edit
    @order_line = OrderLine.find(params[:id])
  end

  # POST /order_lines
  # POST /order_lines.xml
  def create
    @order_line = OrderLine.new(params[:order_line])

    respond_to do |format|
      if @order_line.save
        flash[:notice] = 'OrderLine was successfully created.'
        format.html { redirect_to(@order_line) }
        format.xml  { render :xml => @order_line, :status => :created, :location => @order_line }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @order_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /order_lines/1
  # PUT /order_lines/1.xml
  def update
    @order_line = OrderLine.find(params[:id])

    respond_to do |format|
      if @order_line.update_attributes(params[:order_line])
        flash[:notice] = 'OrderLine was successfully updated.'
        format.html { redirect_to(@order_line) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /order_lines/1
  # DELETE /order_lines/1.xml
  def destroy
    @order_line = OrderLine.find(params[:id])
    @order_line.destroy

    respond_to do |format|
      format.html { redirect_to(order_lines_url) }
      format.xml  { head :ok }
    end
  end
end
