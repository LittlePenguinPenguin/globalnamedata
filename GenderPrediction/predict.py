import pdb
f_standard = open("standard8.csv")
standard_dict = {}
for line in f_standard:
	split = line.strip().split(",")
	#pdb.set_trace()
	if len(split) < 2 or not str.isdigit(split[0].strip()):
		continue
	standard_dict[split[1].lower()] = [split[5],split[6]]

f_gender = open("user_no_gender")
male_count = 0
female_count = 0
norecord_count = 0
total_count = 10000
for line in f_gender:
	split = line.strip().split(",")
	if len(split) < 2 or not str.isdigit(split[0].strip()):
		continue
	est = standard_dict.get(split[1].lower())
	if est:
		print line.strip() + ","+est[0] +"," +est[1]
		if est[0].strip().lower() == 'male':
			male_count += 1
		else:
			female_count += 1
	else:
		print line.strip() + " No Record"
		norecord_count += 1
print "Male : {0}, Percentage : {1}".format(male_count,float(male_count) / total_count)
print "Female : {0}, Percentage : {1}".format(female_count,float(female_count) / total_count)
print "No Record: {0}, Percentage : {1}".format(norecord_count,float(norecord_count) / total_count)
