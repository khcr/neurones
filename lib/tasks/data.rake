namespace :db do 
	desc "Add the pages"
	task pages: :environment do
		Page.create(name: 'home', title: 'title', content: 'content')
		Page.create(name: 'presentation', title: 'title', content: 'content')
		Page.create(name: 'contact', title: 'title', content: 'content')
	end

	desc "Add the user"
	task user: :environment do 
		User.create(email: 'kocher.ke@gmail.com', name: 'Admin', password: '12341', password_confirmation: '12341', level_id: 3)
	end

	desc "Add the levels"
	task levels: :environment do 
		Level.create(name: 'utilisateur')
		Level.create(name: 'admin')
		Level.create(name: 'superadmin')
	end

	desc "Add the events type"
	task types: :environment do
		EventsType.create(name: 'neuroday')
	end

	desc "Add the cantons"
	task cantons: :environment do
		Group::Canton.create(name: 'Fribourg')
	end
end