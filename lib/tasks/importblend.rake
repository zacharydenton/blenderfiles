namespace :blend do
  desc 'import all materials from a blend'
  task :import, [:blend] => :environment do |t, args|
    materials = Material.create_from_blend(args.blend)
    puts "imported #{materials.count} materials"
  end
end
