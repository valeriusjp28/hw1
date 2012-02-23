class Person < ActiveRecord::Base
  attr_accessible :Last, :First, :Pin, :Zip, :Longitude, :Latitude, :City, :State, :Region, :Address, :Country


    validates :Last,      :presence => true,
                          :length   => { :maximum => 50 }

    validates :First,     :presence => true,
                          :length   => { :maximum => 50}

    validates :Region,    :length => { :maximum => 50 }

    validates :Country,   :length => { :maximum => 50 }

    validates :Zip,       :length => { :within => 0..5 }

    validates :Longitude, :length => { :maximum => 180, :greater_than => -180 }

    validates :Latitude,  :length => { :maximum => 90 , :greater_than =>- 90}

    validates :Pingit , :presence     => true,
                          :confirmation => true,
                          :length       => { :within => 1..3 }


end
