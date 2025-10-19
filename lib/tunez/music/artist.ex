defmodule Tunez.Music.Artist do
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

  postgres do
    table "artists"
    repo Tunez.Repo

    custom_indexes do
      index"name gin_trgm_ops", name: "artists_name_gin_index", using: "GIN"
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string do
      public? true
      allow_nil? false
    end
    attribute :biography, :string do
      public? true
    end

    attribute :previous_names, {:array, :string} do
      default []
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :albums, Tunez.Music.Album do
      sort year_released: :desc
    end
  end
  
  actions do
    create :create do
      accept [:name, :biography]
    end
    read :read do
      primary? true
    end

    update :update do
      require_atomic? false
      accept [:name, :biography]

      change Tunez.Music.Changes.UpdatePreviousNames, where: [changing(:name)]
    end

    destroy :destroy do
    end

    read :search do
      argument :query, :ci_string do
        constraints allow_empty?: true
        default""
      end
      filter expr(contains(name, ^arg(:query)))
    end
  end
end
