-- Exercise - connect to a console

-- Tell me how many seconds there are in a week

var days_in_week=7;

days_in_week

-- Tell me how many weeks there are in a human lifetime of 80 years

var weeks_in_year=52.143;
var years=80;
var total_weeks= years*weeks_in_year;
Math.round(total_weeks)

--Exercise - Create a database and collection

show dbs
show collections

use books

db.createCollection('getRich')

show collections

-- Exercise - Create some documents

db.getRich.insert({book_name:'Think and Grow Rich',author:'Napoleon Hill' })
db.getRich.insert({book_name:'Rich Dad Poor Dad',author:'Robert Kiyosaki'})
db.getRich.insert({book_name:'The Intelligent Investor',author:'Benjamin Graham'})
db.getRich.insert({book_name:'The Automatic Millionaire',author:'David Bach'})

-- Exercise - documents
-- Use find() to list them out.

db.getRich.find()

-- Exercise
--We need to start out by inserting some data which we can work with.

-- Paste the following into your terminal to create a petshop with some pets in it

use petshop
db.pets.insert({name: "Mikey", species: "Gerbil"})
db.pets.insert({name: "Davey Bungooligan", species: "Piranha"})
db.pets.insert({name: "Suzy B", species: "Cat"})
db.pets.insert({name: "Mikey", species: "Hotdog"})
db.pets.insert({name: "Terrence", species: "Sausagedog"})
db.pets.insert({name: "Philomena Jones", species: "Cat"})

db.pets.find()

--Add another piranha, and a naked mole rat called Henry
db.pets.insert({species: "Piranha"})
db.pets.insert({name: "Henry", species: "naked mole rat"})

-- Use find to list all the pets. Find the ID of Mikey the Gerbil.

db.pets.find()
-- _id :ObjectId("5fd0dab9ce4342d5aac0f95c")


-- Use find to find Mikey by id.
db.pets.find(ObjectId("5fd0dab9ce4342d5aac0f95c"))

-- Use find to find all the gerbils.

db.pets.find({species: "Gerbil"})

--  Find all the creatures named Mikey.

db.pets.find({name: "Mikey"})

-- Find all the creatures named Mikey who are gerbils.

db.pets.find({name: "Mikey", species: "Gerbil"})

-- Find all the creatures with the string "dog" in their species.

db.pets.find({species: /dog/})


-- Exercise
-- Copy the following code into a Mongo terminal. It will create a collection of people, some of whom will have cats.
-- Optionally modify the code so that some people have piranhas, and some have dachshunds.

use people
(function() {
  var names = [
    'Yolanda',
    'Iska',
    'Malone',
    'Frank',
    'Foxton',
    'Pirate',
    'Poppelhoffen',
    'Elbow',
    'Fluffy',
    'Paphat'
  ]
  var randName = function() {
    var n = names.length;
    return [
      names[Math.floor(Math.random() * n)],
      names[Math.floor(Math.random() * n)]
    ].join(' ');
  }
  var randAge = function(n) {
    return Math.floor(Math.random() * n);
  }
  for (var i = 0; i < 1000; ++i) {
    var person = {
      name: randName(),
      age: randAge(100)
    }
    if (Math.random() > 0.8) {
      person.cat = {
        name: randName(),
        age: randAge(18)
      }
    }
    db.people.insert(person);
  };
})();

-- Use find to get all the people who are exactly 99 years old
b.people.find(
    {
        age:99
        
    }
)

-- Find all the people who are eligible for a bus pass (people older than 65)

db.people.find(
    {
        age:{
            $gt:65
        }
        
    }
)

-- Find all the teenagers, greater than 12 and less than 20.
db.people.find(
    {
        age:{
            $gt:12 ,$lt:20
        }
        
    }
) 

-- Exercise - $exists

-- Find all the people with cats.

db.people.find(
    {
        cat:{
            $exists:true
        }
        
    }
) 

-- Find all the pensioners with cats.


db.people.find(
    {
       age:{
            $gt:65
        }, cat:{
            $exists:true
        }
        
    }
) 

-- Find all the teenagers with teenage cats.

db.people.find(
    {
        $where:"this.age>12 && this.age<20 && this.cat!=null && this.cat.age>12 && this.cat.age<20"
    }
)



-- Exercise - $where

--Use $where to find all the people who have a cat.

db.people.find(
    {
        $where: "this.cat!=null"
    }
)

-- Find all the people who are younger than their cats. Remember, not everyone has a cat, so you will need to use a boolean && to filter out the non-cat owners.

db.people.find(
    {
        $where: "this.cat!=null && this.cat.age>this.age"
    }
)

-- Does anyone have the same name as their cat? Re-run the insertion script to create more records until someone does.

db.people.find(
    {
        $where: "this.cat!=null && this.cat.name == this.name"
    }
)

-- Exercise - count the people

-- Find out how many people there are in total

db.people.count()

db.people.find().count()

-- Using your collection of people, and $exists, tell me how many people have cats.

db.people.count(
    {
        cat:{
            $exists:true
        }
    }
)

-- Use $where to count how many people have cats which are older than them

db.people.count(
    {
        $where: "this.cat!=null && this.cat.age > this.age"
    }
)

-- Exercise - Limit the people

--Give me the first 5 people

db.people.find().limit(5)

-- Give me the next 5 people

db.people.find().skip(5).limit(5)

-- Give me the names and ages of the oldest 5 pensioners with piranhas

db.people.find({
    piranhas:{
        $exists:true
    }
},{name:true,age:true}).sort({age:-1}).limit(5)

-- Give me the names and ages of the youngest 5 teenagers with cats, where the cats have the word "Yolanda" in their name

db.people.find({
   $where:"this.cat!=null && this.age>12 && this.age<20",

    "cat.name":/Yolanda/
   
    
},{name:true,age:true,_id:false}).sort({age:1}).limit(5)

-- Exercise - Order the people

-- Find the youngest 1 person with a cat and a piranha.
db.people.find(
    {
        cat:{
            $exists:true
        },
        piranha:{
            $exists:true
        }
    }
).sort({age:1}).limit(1)

-- Give me just the name of the youngest 1 person with a cat and a piranha.

db.people.find(
    {
        cat:{
            $exists:true
        }
    },{
        name:true,_id:false
    }
).sort({age:1}).limit(1)

-- Give me the 5 oldest cats

db.people.find({},{cat:true ,_id:false}).sort({"cat.age":-1}).limit(5)

-- Give me the next 5 oldest cats

db.people.find({},{cat:true ,_id:false}).sort({"cat.age":-1}).limit(5).skip(5)



-- Exercise - Create a document

-- Refresh your muscle memory. Create a new person now. Ensure that person has a shark.

db.people.insert(
    {
    name:'chinmya' ,age:21, shark:{age:10, name:"ganji"}
    }
)

-- Exercise - Find the shark

-- Refresh your muscle memory. Find the person who has a shark
db.people.find({
    shark:{
        $exists:true
    }
})

-- Use findOne instead of find. This will return only one document.

db.people.findOne({
    shark:{
        $exists:true
    }
})

-- Exercise - Make everyone older

-- Exercise - Make everyone older
-- A year has gone by. Write a loop that iterates over a cursor and makes everyone one year older.
-- Remember to make the cats older too. See if you can do both in the same loop.


db.people.find(cat:{
        $exists:true
    }).forEach(function(person) {
    
    person.age=person.age+1;
    db.people.save(person);

    person.cat.age+=1;
    db.people.save(person);
  
});

-- Exercise - Pirates
--Find everyone who has the word 'Pirate' in their name. You will need to use a regular expression to do this. {name: /Pirate/}

db.people.find({
    name: /Pirate/
})

-- Exercise - remove all the people.
--It's time for a cull. Delete all the 50 year olds.

db.people.remove({age:50})

-- We also heard there was some guy running round with a shark. That's a dangerous animal. Take him out, in fact take out anyone with a shark.

db.people.remove({
    shark:{
        $exists:true
    }
})
