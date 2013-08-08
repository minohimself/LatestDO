class PostaController < ApplicationController
  # GET /posta
  # GET /posta.json


  def index
	  @posta = Postum.includes(:recipients).where('recipients.prijemca' => current_user)

	  respond_to do |format|
      format.html # index.html.erb
		  format.json { render json: @posta }
    end
  end

  def odoslane
	  @recipient_array = User.all.map &:nick
	  @posta = Postum.includes(:recipients).where('recipients.user_id' => current_user)

	  @postum = Postum.new(params[:postum])

	  respond_to do |format|

		  format.html # odoslane.html.erb
		  format.json { render json: @posta }

	  end
  end



  # GET /posta/1
  # GET /posta/1.json
  def show
    @postum = Postum.find(params[:id])
    Postum.procist(@postum)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @postum }
    end
  end

  # GET /posta/new
  # GET /posta/new.json
  def new
	  @recipient_array = User.all.map &:nick
    @postum = Postum.new


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @postum }
    end
  end

  # GET /posta/1/edit
  def edit
    @postum = Postum.find(params[:id])
  end

  # POST /posta
  # POST /posta.json
  def create
    @postum = Postum.new(params[:postum])


    respond_to do |format|
      if @postum.save
	      Postum.posliPostu(current_user,@postum.prijimatelia,@postum)
        #format.html #{ render 'posta/postum', notice: 'Postum was successfully created.' }
        format.json { render json: @postum, status: :created, location: @postum }
	      #format.js
      else
        format.html { render action: "new" }
        format.json { render json: @postum.errors, status: :unprocessable_entity }
        #format.js
      end
    end
  end

  # PUT /posta/1
  # PUT /posta/1.json
  def update
    @postum = Postum.find(params[:id])

    respond_to do |format|
      if @postum.update_attributes(params[:postum])
        format.html { redirect_to @postum, notice: 'Postum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @postum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posta/1
  # DELETE /posta/1.json
  def destroy
    @postum = Postum.find(params[:id])
    @postum.destroy

    respond_to do |format|
      format.html { redirect_to posta_url, :notice =>"The user was successfully created"}
      format.js   { render :layout => false }
      format.json { head :no_content }
    end
  end
end
