ActiveRecord::Schema.define(version: 2019_04_05_145301) do
  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", null: false
    t.datetime "confirmation_sent_at", null: false
    t.string "phone_confirmation_code"
    t.datetime "phone_confirmed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_confirmed_at"] # no index names, just showing fields
    t.index ["confirmed_at"]
  end

  create_table "profiles", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.integer "user_id"
    t.string "avatar" # for carrierwave uploader
    t.text "bio"
    t.string "website_url"
    t.string "facebook_url"
    t.string "streaming_platform_url"
    t.string "twitter_handle"
    t.string "instagram_handle"
    t.integer "average_reply_delay"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"]
    t.index ["average_reply_delay"]
  end

  create_table "payment_infos", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.string "country" # basically an enum, because there is a limited list of available countries
    t.string "city"
    t.string "address"
    t.string "postal_code"
    t.string "sort_code"
    t.string "bank_account_number"
    t.string "iban"
    t.string "routing_number"
    t.string "stripe_customer_id" # for saving after first stripe charge
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"]
  end

  create_table "studios", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "details"
    t.string "min_booking_duration"
    t.string "working_hours"
    t.text "past_clients"
    t.text "audio_samples"
    t.text "amenities"
    t.text "main_equipment"
    t.text "rules"
    t.boolean "cancellation_policy_agreement", default: false
    t.decimal "price_per_hour", default: 0, precision: 10, scale: 2
    t.boolean "audio_engineer_included", default: false
    t.integer "status" # enum - probably something like draft, published, maybe something_else
    t.datetime "verified_at", null: false # I don't know logic behind verification badge
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"]
    t.index ["audio_engineer_included"]
    t.index ["status"]
    t.index ["verified_at"]
  end

  create_table "studios_studio_types", force: :cascade do |t|
    t.integer "studio_id"
    t.integer "studio_type_id"
    t.index ["studio_id", "studio_type_id"], unique: true
  end

  create_table "studio_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.integer "addressable_id"
    t.string "addressable_type"
    t.string "address"
    t.string "apartment_info"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_id", "addressable_type"]
    t.index ["latitude"]
    t.index ["longitude"]
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.integer "photoable_id"
    t.string "photoable_type"
    t.string "image" # for carrierwave uploader
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["photoable_id", "photoable_type"]
  end

  create_table "bookings", id: :serial, force: :cascade do |t|
    t.integer "studio_id"
    t.integer "user_id"
    t.boolean "cancellation_policy_agreement"
    t.boolean "government_id_agreement"
    t.text "notes"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["studio_id"]
    t.index ["user_id"]
    t.index ["status"]
  end

  # I can't make a booking, so it's a pure guess on conversation database structure
  create_table "booking_messages", id: :serial, force: :cascade do |t|
    t.integer "booking_id"
    t.integer "sender_user_id"
    t.integer "receiver_user_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"]
    t.index ["sender_user_id"]
    t.index ["receiver_user_id"]
  end

  create_table "booking_days", id: :serial, force: :cascade do |t|
    t.integer "booking_id"
    t.date "booking_on"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"]
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "orderable_id"
    t.integer "orderable_type"
    t.decimal "amount", precision: 10, scale: 2, default: 0
    t.string "reference" # stripe charge reference for example
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["orderable_id", "orderable_type"]
    t.index ["status"]
  end

  create_table "reviews", id: :serial, force: :cascade do |t|
    t.integer "booking_id"
    t.integer "score", default: 0
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"]
    t.index ["score"]
  end
end

