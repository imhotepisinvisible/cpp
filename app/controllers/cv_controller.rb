class CvController < ApplicationController
  respond_to :json

  def index
    logger.debug 'hi'
    head :no_content
  end

  # POST /cv
  # POST /cv.json
  def create
    # File saved in /tmp
    tempfile = params[:files][0].tempfile

    # Make new file name for the CV
    file = File.join('cvs', params[:files][0].original_filename)

    # Copy temporary file to new place /cvs
    FileUtils.cp tempfile.path, file
    head :no_content
  end
end