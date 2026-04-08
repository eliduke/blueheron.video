require "open-uri"

namespace :active_storage_refactor do
  desc "Copies `object.image.attached?` into `image_attached` for all bands and venues"
  task image_attached_backup: :environment do
    puts "=> Backing up bands:\n"
    Band.all.each do |band|
      band.update_attribute(:image_attached, band.image.attached? )
      print "."
    end

    puts "=> Backing up venues:\n\n"
    Venue.all.each do |venue|
      venue.update_attribute(:image_attached, venue.image.attached? )
      print "."
    end
  end

  desc "Reattaches band images"
  task reattach_band_images: :environment do
    puts "Reattaching band images:\n"
    Band.where(image_attached: true).each do |band|
      band.image.attach(
        key: "bands/#{band.id}.jpg",
        io: URI.open("https://assets.eliduke.com/blue-heron-video-images/bands/#{band.id}.jpg"),
        content_type: "image/jpeg",
        filename: "#{band.id}.jpg"
      )
      print "."
    end
  end

  desc "Reattaches venue images"
  task reattach_venue_images: :environment do
    puts "Reattaching venue images:\n"
    Venue.all.where(image_attached: true).each do |venue|
      venue.image.attach(
        key: "venues/#{venue.id}.jpg",
        io: URI.open("https://assets.eliduke.com/blue-heron-video-images/venues/#{venue.id}.jpg"),
        content_type: "image/jpeg",
        filename: "#{venue.id}.jpg"
      )
      print "."
    end
  end
end
