task :importblend, [:blend] => :environment do |t, args|
  materials = Material.create_from_blend(args.blend)
  puts "imported #{materials.count} materials"
end


