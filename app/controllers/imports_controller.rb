class ImportsController < ApplicationController
  before_action :set_import, only: [:update, :destroy]

  # GET /imports
  # GET /imports.json
  def index
    @imports = Import.all
  end

  # GET /imports/1
  # GET /imports/1.json
  def show
  end

  #### File Importer Endpoint ####

  # POST /imports
  # POST /imports.json
  def create
    @import = Import.new(import_type: import_params[:import_type], filename: import_params[:file].original_filename)
    if @import.valid_file_type?(import_params)
      @import.save
      @export_json = @import.handle_import_file(@import.import_type, import_params[:file])
    else
      #Handle error message response
      @export_json = 'File format must be a csv'
    end
    respond_to do |format|
      # format.html { redirect_to imports_path(@export_json) }
      format.json {render json: @export_json }
    end
  end

  # PATCH/PUT /imports/1
  # PATCH/PUT /imports/1.json
  def update
    respond_to do |format|
      if @import.update(import_params)
        format.html { redirect_to @import, notice: 'Import was successfully updated.' }
        format.json { render :show, status: :ok, location: @import }
      else
        format.html { render :edit }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /imports/1
  # DELETE /imports/1.json
  def destroy
    @import.destroy
    respond_to do |format|
      format.html { redirect_to imports_url, notice: 'Import was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import
      @import = Import.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def import_params
      params.permit(:import_type, :file)
    end
end
