# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

list = List.create(name: "TODO")
list.tasks.create(name: 'write a report')
list.tasks.create(name: 'buy a ticket')
list.tasks.create(name: 'feed the cat')


list = List.create(name: "In progress")
list = List.create(name: "Done")
