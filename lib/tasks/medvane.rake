namespace :mdvn do
  desc "Updates Journal from PubMed"
  task :journals => :environment do
    Medvane::Setup.journals
  end

  desc "Setup Medvane using background job"
  task :setup => :environment do
    ['journals', 'taxonomies', 'published_genes', 'genes'].each do |task|
      Delayed::Job.enqueue(SetupJob.new(task))
      puts "[#{Time.now.to_s}] enqueued SetupJob.new(#{task})"
    end
  end

  namespace :genes do
    desc "Updates Gene and related models"
    task :all => :environment do
      ['published', 'gene', 'taxonomy'].each do |task|
        Rake::Task["mdvn:genes:#{task}"].invoke
      end
    end

    desc "Updates PublishedGene from PubMed"
    task :published => :environment do
      Medvane::Setup.published_genes
    end

    desc "Updates Gene from PubMed"
    task :gene => :environment do
      Medvane::Setup.genes
    end

    desc "Updates Taxonomy from PubMed"
    task :taxonomy => :environment do
      Medvane::Setup.taxonomies
    end
  end
end
