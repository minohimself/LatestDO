class TechnologiesController < ApplicationController
  # GET /technologies
  # GET /technologies.json
  def index
    @technologies = Technology.includes(:researches).where(:discovered => 1)

    case params[:kind]
	    when 'L'
		    @syselaads = Syselaad.landsraadsky
	    when 'N'
		    @syselaads = Syselaad.narodni.where(:house_id => rod)
	    when 'I'
		    @syselaads = Syselaad.imperialni
	    when 'S'
		    @syselaads = Syselaad.systemovy
	    when 'E'
		    @syselaads = Syselaad.mezinarodni
	    else
		    @syselaads = Syselaad.narodni.where(:house_id => rod)
    end


    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @technologies }
	   # #format.js
    #end
  end

  # GET /technologies/1
  # GET /technologies/1.json
  def show
    @technology = Technology.find(params[:id])
     respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @technology }
    end
  end

  # GET /technologies/new
  # GET /technologies/new.json
  def new
    @technology = Technology.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @technology }
    end
  end

  # GET /technologies/1/edit
  def edit
    @technology = Technology.find(params[:id])

  end

  def vylepsi_technology
    @technologies = Technology.all
    @technology = Technology.find(params[:technology])
    @vylepseno = @technology.vylepseno(current_user)

    cena_tech = @technology.cena_technology(current_user)
    if @technology.vylepseno(current_user) == @technology.max_lvl
      flash[:error] = "Vyzkum na nejvissi urovni"
      redirect_to :action => 'index', :layout=>false
      #flash.now[:notice] = 'Your message'
      #respond_to do |format|

	     # format.html { redirect_to(index, notice: 'Vyskum na najvyssej urovni.') }
	     # format.json { render json: @technology }
	     # #format.js
      #
      #end
    else
      if cena_tech > current_user.exp
        flash[:error] = "Nedostatok zkusenosti pro vynalezeni, potreba #{(cena_tech - current_user.exp).round(0)} exp."
        redirect_to :action => 'index', :layout=>false
	      #flash.now[:notice] = "Your message"
        #respond_to do |format|
	       # format.html { redirect_to(index, :notice => 'Malo exp.') }
	       # format.json { render json: @technology }
	       # format.js
        #
        #end
      else
        @technology.vylepsi(current_user)
        current_user.update_attributes(:exp => (current_user.exp - cena_tech))
        flash[:notice] = "Vyzkum byl vynalezen ."
        redirect_to :action => 'index', :layout=>false
        #, :notice => 'Technology created.'
       # respond_to do |format|
	      #  format.html { redirect_to(index) }
	      #  format.json { render json: @technology }
	      #  format.js
       #end

      end
    end

  end


  # DELETE /technologies/1
  # DELETE /technologies/1.json
  def destroy
    @technology = Technology.find(params[:id])
    @technology.destroy

    respond_to do |format|
      format.html { redirect_to technologies_url }
      format.json { head :no_content }
    end
  end
end
