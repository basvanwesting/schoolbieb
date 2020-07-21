class Book::NonFiction < Book
  validates :category, presence: true
  before_save :flatten_tags

  def flatten_tags
    self.tags = tags.flatten.uniq.sort.reject(&:blank?)
  end

  module Categories
    DATA = {
      "Beroepen"                   => { fas_icon: "fa-chalkboard-teacher" },
      "Computers & Gamen & Online" => { fas_icon: "fa-desktop"            },
      "Dieren"                     => { fas_icon: "fa-paw"                },
      "Eten & Drinken"             => { fas_icon: "fa-utensils"           },
      "Feest"                      => { fas_icon: "fa-birthday-cake"      },
      "Gedichten & Versjes"        => { fas_icon: "fa-feather-alt"        },
      "Geschiedenis"               => { fas_icon: "fa-landmark"           },
      "Godsdienst"                 => { fas_icon: "fa-praying-hands"      },
      "Hobby's"                    => { fas_icon: "fa-cut"                },
      "Huis & Tuin"                => { fas_icon: "fa-home"               },
      "Kunst & Cultuur"            => { fas_icon: "fa-palette"            },
      "Landen & Volken"            => { fas_icon: "fa-globe-americas"     },
      "Lichaam & Gezondheid"       => { fas_icon: "fa-heartbeat"          },
      "Mens & Maatschappij"        => { fas_icon: "fa-users"              },
      "Muziek"                     => { fas_icon: "fa-music"              },
      "Natuur & Milieu"            => { fas_icon: "fa-tree"               },
      "Nederland"                  => { fas_icon: "fa-map-marked-alt"     },
      "Schrijvers & Boeken"        => { fas_icon: "fa-book-reader"        },
      "Sport & Spel"               => { fas_icon: "fa-futbol"             },
      "Sprookjes & Volksverhalen"  => { fas_icon: "fa-hat-wizard"         },
      "Theater & Film"             => { fas_icon: "fa-theater-masks"      },
      "Verkeer & Vervoer"          => { fas_icon: "fa-car-side"           },
      "Wetenschap & Techniek"      => { fas_icon: "fa-flask"              },
    }.freeze

    ALL = DATA.keys.freeze

    def self.fas_icon_for(name)
      DATA.fetch(name, { fas_icon: '' }).fetch(:fas_icon)
    end
  end

  class << self
    def sorted_existing_tags
      pluck(Arel.sql("distinct unnest(tags)")).sort
    end

    def with_tag(tag)
      where("? = ANY (tags)", tag)
    end
  end
end
