
["Elsevier", "John Wiley and Sons", "Taylor & Francis", "American Mathematical Society"].each { |n|

  p = Publisher.find_by_name(n)
  if (not p.nil?) then
    p.destroy();
  end
  p = Publisher.create(:name => n)

}
Publisher.reindex

p = Publisher.find_by_name("Elsevier")
[ "Fuel Cells Bulletin",
"Lancet",
"Lancet (North American Edition)",
"Lancet Diabetes and Endocrinology",
"Lancet Global Health    -",
"Lancet Infectious Diseases",
"Lancet Neurology",
"Lancet Oncology",
"Lancet Respiratory Medicine",
"Zoologische Garten",
"Zoologischer Anzeiger",
"Zoology"].each { |j|
    Journal.create(:publisher => p, :name => j)
}
Journal.reindex



p = Publisher.find_by_name("American Mathematical Society")
["Abstracts of Papers Presented to the AMS",
 "Bulletin of the American Mathematical Society",
 "Conformal Geometry and Dynamics",
 "Electronic Research Announcements of the American Mathematical Society",
 "Journal of the American Mathematical Society",
 "Mathematical Reviews",
 "Mathematics of Computation",
 "Memoirs of the American Mathematical Society",
 "Notices of the American Mathematical Society",
 "Proceedings of the American Mathematical Society",
 "Proceedings of the American Mathematical Society: Series B",
 "Representation Theory",
 "St. Petersburg Mathematical Journal",
 "Sugaku Expositions",
 "Theory of Probability and Mathematical Statistics",
 "Tranactions of the Moscow Mathematical Society",
 "Transactions of the American Mathematical Society",
 "Transactions of the American Mathematical Society: Series B"].each { |j|
  Journal.create(:publisher => p, :name => j)
}
Journal.reindex


p = Publisher.find_by_name("John Wiley and Sons")
File.open("wiley.journals", "r").readlines().each { |l|
  puts l
  Journal.create(:publisher => p, :name => l.strip())
}
Journal.reindex

p = Publisher.find_by_name("Taylor & Francis")
File.open("taylorfrancis.journals", "r").readlines().each { |l|
  puts l
  Journal.create(:publisher => p, :name => l.strip())
}
Journal.reindex






