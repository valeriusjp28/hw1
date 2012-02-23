class PeopleController < ApplicationController
   include Geokit::Geocoders
  # GET /people
  # GET /people.xml
  def list
    @people = Person.all

    respond_to do |format|
      format.html # list.html.erb
      format.xml  { render :xml => @people }
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/index
  # GET /people/index.xml
  def index
    @person = Person.new
    if cookies[:user_id] != nil
      @person = Person.where(:id => cookies[:user_id].to_i)
      if @person != nil
        session[:sid] = cookies[:user_id]
        redirect_to :action => "soptions"
        return
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
  end

  def map
    @people = Person.all

    @people.each do |person|
      if person.Latitude.empty?
        if not person.Address.empty?
          @address = MultiGeocoder.geocode(person.Address + ' ' + person.City + ', ' + person.State)
          person.Latitude=@address.lat
          person.Longitude=@address.lng
        end
        if not person.Zip.empty?
          @city = MultiGeocoder.geocode(person.Zip)
          person.Latitude=@city.lat
          person.Longitude=@city.lng
        end

        if person.Zip.empty? & person.Address.empty?
          @ip = MultiGeocoder.geocode(request.remote_ip)
          person.Latitude=@ip.lat
          person.Longitude=@ip.lng
        end
      end
    end
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])
    respond_to do |format|

      if @person.save
        #create cookies
        cookies[:user_id] = {:value => @person.id.to_s, :expires => Time.now + 30000}
        cookies[:user_name] = {:value => params[:person][:last], :expires => Time.now + 30000}
        cookies[:full_address] = {:value => params[:person][:address], :expires => Time.now + 30000}
        format.html { redirect_to :action => 'soptions' }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to(@person, :notice => 'Person was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end

  def soptions
    @person = Person.find_by_id(Person.where(:id => cookies[:user_id].to_i))
    #Converting addresses and IP's to lat long for the map'
    respond_to do |format|
      format.html # list.html.erb      format.xml  { render :xml => @people }
    end
  end
end
