class JournalsController < ApplicationController
  # GET /journals
  # GET /journals.json
  def index

    page = params[:page] || 1
    query = params[:query] || ''

    searcher = Journal.search do
      fulltext query
      paginate(:page => page, :per_page => 15)

      order_by(:score, :desc)
      order_by(:name_sortable, :asc)
    end

    @results = Kaminari.paginate_array(
        searcher.results, total_count: searcher.hits.total_count).page(page).per(15)

    respond_to do |format|
      format.html { render 'refable/index' }
      # format.json { render :json => @journals }
    end
  end

  # GET /journals/1
  # GET /journals/1.json
  def show
    @refable = Journal.find(params[:id])

    respond_to do |format|
      format.html { render 'refable/show' }
      # format.json { render :json => @journal }
    end
  end

  # GET /journals/new
  # GET /journals/new.json
  # def new
  #   @journal = Journal.new

  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.json { render :json => @journal }
  #   end
  # end

  # GET /journals/1/edit
  def edit
    @refable = Journal.find(params[:id])

    render 'refable/edit'
  end

  # # POST /journals
  # # POST /journals.json
  # def create
  #   @journal = Journal.new(params[:journal])

  #   respond_to do |format|
  #     if @journal.save
  #       format.html { redirect_to @journal, :notice => 'Journal was successfully created.' }
  #       format.json { render :json => @journal, :status => :created, :location => @journal }
  #     else
  #       format.html { render :action => "new" }
  #       format.json { render :json => @journal.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  # PUT /journals/1
  # PUT /journals/1.json
  def update
    @refable = Journal.find(params[:id])

    respond_to do |format|
      if @refable.update_attributes(params[:journal])
        format.html { redirect_to journal_path(@refable), :notice => 'Journal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @refable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # # DELETE /journals/1
  # # DELETE /journals/1.json
  # def destroy
  #   @journal = Journal.find(params[:id])
  #   @journal.destroy

  #   respond_to do |format|
  #     format.html { redirect_to journals_url }
  #     format.json { head :no_content }
  #   end
  # end
end
