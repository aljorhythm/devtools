const fs = require('fs')

const lengths = process.argv[2].split(",").map(l => parseInt(l))

for(const length of lengths) {
    const base = `this string has ${length}.`
    const full = `[START]${Array.from({length: 1 + (length / base.length)})
        .map(() => base)
        .join("")}`.slice(0, length - 5) + "[END]"
    
    fs.writeFileSync(`text-with-length-${length}.out`, full)
}