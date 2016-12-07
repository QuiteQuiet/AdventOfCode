import re
# part 1
tls = re.compile(r'([a-z])(?!\1)([a-z])\2\1')
hyper = re.compile(r'\[.*?\]')
counter = 0
with open('input.txt') as f:
	for l in f:
		valid = bool(re.search(tls, l))
		for match in re.finditer(hyper, l):
			valid = valid and not bool(re.search(tls, match.group()))
		if valid:
			counter += 1
print('Part 1:', counter)
# part 2
ssl = re.compile(r'(?=((.)(?!\2)(.)\2))')
counter = 0
with open('input.txt') as f:
	for l in f:
		possible = [m[0] for m in re.findall(ssl, l)]
		pairs = [(p1, '{1}{0}{1}'.format(p1[0], p1[1])) for p1 in possible if '{1}{0}{1}'.format(p1[0], p1[1]) in possible]
		if [pair for pair in pairs if pair[0] in hyper.sub('|', l) and pair[1] in ''.join(re.findall(hyper, l))]:
			counter += 1
print('Part 2:', counter)
