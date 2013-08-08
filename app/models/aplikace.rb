# encoding: utf-8
class Aplikace
  include ApplicationHelper
  
  VEK = '1'

  def self.prihlaseni_povoleno?
    Global.vrat('login', 1)
  end

  def self.zakladani_hracu_povoleno?
    Global.vrat('signup', 1)
  end

#  def self.wkhtmltopdf_path_to_bin
#    #TODO casem optimalizovat pro vsechny os
#    #a = ''
#    #if ENV["RAILS_ENV"] == 'production'
#    #  a = "#{Rails.root}/wkhtmltopdf_bin/linux/wkhtmltopdf-amd64"
#    #else
#      a = "#{Rails.root}/wkhtmltopdf_bin/linux/wkhtmltopdf-i386"
#    #end
#    return a
#  end
#
#  def self.cesta_pro_pdf(filename)
#    Rails.root.join('pdfs', "#{filename}.pdf")
#  end
  
  def self.zamkni_hru
    if Aplikace.prihlaseni_povoleno?
      Global.prepni('login', 1, false)
    end
    Aplikace.odhlas_hrace
  end
  
  def self.odemkni_hru
    unless Aplikace.prihlaseni_povoleno?
      Global.prepni('login', 1, true)
    end
  end

  def self.odhlas_hrace
    sessions = Session.all
    sessions.each do |session|
      user = Marshal.load(ActiveSupport::Base64.decode64(session.data))["user_id"]
      if user
        unless User.find(user).admin?
          session.delete
        end
      else
        session.delete
      end
    end
  end

  def self.wipe
    puts "WIPE"
    AppLog.delete_all
    Eod.delete_all
    Environment.delete_all
    Estate.delete_all
    Resource.delete_all
    Influence.delete_all
    Law.delete_all
    Poll.delete_all
    #Syselaad.delete_all
    #Post.delete_all
    #Topic.delete_all
    Operation.delete_all
    Vote.delete_all

    for field in Field.all do
      if field.planet.domovska?
        field.vytvor_resource
        field.postav(Building.where(:kind => "L", :level => [1]).first, 2)
        field.postav(Building.where(:kind => "S", :level => [1]).first, 2)
        field.postav(Building.where(:kind => "M", :level => [1]).first, 2)
        field.postav(Building.where(:kind => "E", :level => [1]).first, 2)
      else
        field.delete
      end

    end

    for hou in House.playable do
      hou.update_attributes(:solar => 10000.0, :melange => 50.0, :material => 50000.0, :exp => 100.0, :melange_percent => 3.0)
    end

    for hou in House.all do
      hou.update_attribute(:influence, 1.0)
    end

    for pla in Planet.all do
      if pla.domovska?

      else
        pla.delete
      end
    end
    
    for disc in Discoverable.all do
      if Planet.find_by_name(disc.name)

      else
        disc.update_attribute(:discovered, false)
      end
    end

    for user in User.all do
      if user.admin?
        user.hlasuj(User.find_by_username('Norma_Cenva'),'leader')
      else
        user.napln_suroviny
        user.update_attributes(:leader => false,
                               :mentat => false,
                               :army_mentat => false,
                               :diplomat => false,
                               :general => false,
                               :vicegeneral => false,
                               :landsraad => false,
                               :arrakis => false,
                               :emperor => false,
                               :regent => false,
                               :court => false,
                               :vezir => false,
                               :admin => false)
        user.hlasuj(user,'leader')
      end
    end

    for house in House.playable do
      i = 0
      2.times do
        i += 1
        planet = house.kolonizuj_planetu
        if i % 2 == 0
          planet.update_attribute(:available_to_all, true)
        end
        planet.save
      end
    end
    puts 'Vychozi planety objeveny'

    arrakis = Planet.create(:name => 'Arrakis',
                            :planet_type_id => PlanetType.find_by_name('Marganský typ').id,
                            :house_id => House.find_by_name('Impérium').id,
                            :available_to_all => false,
                            :discovered_at => Date.today,
                            :position => 1,
                            :system_name => "Mu Draconis")

    Planet.arrakis.fields << Field.new(:name => "Leno Arrakis",
                                       :planet_id => arrakis.id,
                                       :user_id => nil,
                                       :pos_x => 1,
                                       :pos_y => 1
    )
    arrakis_field = Field.find_by_planet_id(arrakis)
    arrakis_field.vytvor_resource
    arraken = Building.where(:name => "Arraken").first
    arrakis_field.postav(arraken, 1)
    harvester = Building.where(:name => "Továrna na koření").first
    arrakis_field.postav(harvester, 10)
    puts "Budovy na Arrakis postaveny"

    #for house in House.playable do
    #  Syselaad.create(
    #      :house_id => house.id,
    #      :subhouse_id => nil,
    #      :kind => 'N',
    #      :name => "Syselaad #{house.name}",
    #      :description => "Syselaad národu #{house.name}"
    #  )
    #end
    #
    #Syselaad.create(
    #    :house_id => nil, :subhouse_id => nil, :kind => 'I', :name => "Imperiální Syselaad",
    #    :description => "Imperiální Syselaad")
    #Syselaad.create(
    #    :house_id => nil, :subhouse_id => nil, :kind => 'L', :name => "Landsraadský Syselaad",
    #    :description => "Landsraadský Syselaad")
    #Syselaad.create(
    #    :house_id => nil, :subhouse_id => nil, :kind => 'S', :name => "Systémový Syselaad",
    #    :description => "Systémový Syselaad")
    #Syselaad.create(
    #    :house_id => nil, :subhouse_id => nil, :kind => 'E', :name => "Mezinárodní Syselaad",
    #    :description => "Mezinárodní Syselaad")
    #
    #for syselaad in Syselaad.all do
    #  syselaad.topics << Topic.create(:syselaad_id => syselaad.id, :user_id => 1, :name => 'Úvod',
    #                                  :last_poster_id => 1, :last_post_at => Time.now, )
    #end
    #for topic in Topic.all do
    #  topic.posts << Post.create(:topic_id => topic.id, :user_id => 1, :content => 'Vítejte!')
    #end

    User.find_by_username('Doktor').jmenuj_spravcem

    puts 'Prepocet spusten'
    Prepocet.prepocti_vliv
    Prepocet.kompletni_prepocet
    puts 'Prepocet dokoncen'

    puts 'WIPE KONEC'
  end

end