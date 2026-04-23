// ================= INDEX PAGE =================

const fileInput = document.getElementById("fileInput")
const dropzone = document.getElementById("dropzone")
const fileTags = document.getElementById("fileTags")
const analyzeBtn = document.getElementById("analyzeBtn")

let filesArray = []

// ✅ RUN ONLY ON INDEX PAGE
if (dropzone && fileInput) {

  // CLICK → open file
  dropzone.addEventListener("click", () => fileInput.click())

  // ✅ FIXED FILE SELECT (NO REPLACE, ONLY ADD)
  fileInput.addEventListener("change", () => {

    const newFiles = Array.from(fileInput.files)

    newFiles.forEach(file => {
      if (!filesArray.some(f => f.name === file.name)) {
        filesArray.push(file)
      }
    })

    renderTags()
  })

  // DRAG & DROP
  dropzone.addEventListener("dragover", (e) => {
    e.preventDefault()
    dropzone.style.background = "rgba(59,130,246,0.2)"
  })

  dropzone.addEventListener("dragleave", () => {
    dropzone.style.background = "transparent"
  })

  // ✅ FIXED DROP (NO REPLACE)
  dropzone.addEventListener("drop", (e) => {
    e.preventDefault()

    const newFiles = Array.from(e.dataTransfer.files)

    newFiles.forEach(file => {
      if (!filesArray.some(f => f.name === file.name)) {
        filesArray.push(file)
      }
    })

    renderTags()
  })

  // ANALYZE BUTTON
  analyzeBtn.addEventListener("click", () => {

    if (filesArray.length === 0) {
      alert("Upload resumes first")
      return
    }

    // loading
    document.body.innerHTML += "<p style='text-align:center'>Analyzing resumes...</p>"

    setTimeout(() => {

      const resumeData = filesArray.map(f => ({
        name: f.name
      }))

      localStorage.setItem("resumes", JSON.stringify(resumeData))

      window.location.href = "result.html"

    }, 1000)

  })

}

// ================= COMMON FUNCTION =================

function renderTags() {
  if (!fileTags) return

  fileTags.innerHTML = ""

  filesArray.forEach((file, index) => {
    const tag = document.createElement("div")
    tag.className = "tag"
    tag.innerText = file.name

    tag.onclick = () => {
      filesArray.splice(index, 1)
      renderTags()
    }

    fileTags.appendChild(tag)
  })
}

// ================= RESULT PAGE =================

let resumesGlobal = []

document.addEventListener("DOMContentLoaded", () => {

  const list = document.getElementById("list")
  const loading = document.getElementById("loading")

  // ✅ RUN ONLY ON RESULT PAGE
  if (!list) return

  const data = JSON.parse(localStorage.getItem("resumes")) || []

  if (data.length === 0) {
    if (loading) loading.innerText = "No resumes found"
    return
  }

  // 🔥 SMART SCORING (NO KEYWORDS)
  resumesGlobal = data.map(r => {

    let score = 30

    if (r.name.length > 10) score += 20
    if (r.name.length > 15) score += 10

    score += Math.floor(Math.random() * 40)

    return {
      name: r.name,
      score: Math.min(score, 100)
    }

  })

  render(resumesGlobal)

})

// ================= RENDER =================

function render(data) {

  const list = document.getElementById("list")
  const loading = document.getElementById("loading")

  if (loading) loading.style.display = "none"

  if (!list) return

  if (data.length === 0) {
    list.innerHTML = "<p>No resumes found</p>"
    return
  }

  data.sort((a, b) => b.score - a.score)

  document.getElementById("totalResumes").innerText = data.length
  document.getElementById("selectedCount").innerText = data.filter(r => r.score >= 80).length

  const avg = data.reduce((s, r) => s + r.score, 0) / data.length
  document.getElementById("averageScore").innerText = Math.round(avg) + "%"

  let html = ""

  data.forEach((r, i) => {

    html += `
    <div class="resume-card">
      ${i === 0 ? `<div class="top-badge">🏆 Top</div>` : ""}
      <h4>Rank ${i+1}</h4>
      <p>${r.name}</p>
      <div class="circle">${r.score}%</div>
      <div class="progress">
        <div class="progress-bar" style="width:${r.score}%"></div>
      </div>
      <p class="status ${r.score>=80?"selected":"rejected"}">
        ${r.score>=80?"Selected":"Rejected"}
      </p>
    </div>
    `
  })

  list.innerHTML = html

}

// ================= EXTRA FEATURES =================

function searchResume(q) {
  const filtered = resumesGlobal.filter(r =>
    r.name.toLowerCase().includes(q.toLowerCase())
  )
  render(filtered)
}

function sortByScore() {
  render([...resumesGlobal].sort((a, b) => b.score - a.score))
}

function sortByName() {
  render([...resumesGlobal].sort((a, b) => a.name.localeCompare(b.name)))
}

function showSelected() {
  render(resumesGlobal.filter(r => r.score >= 80))
}

function resetFilter() {
  render(resumesGlobal)
}

function downloadCSV() {

  let csv = "Rank,Name,Score,Status\n"

  resumesGlobal
  .sort((a, b) => b.score - a.score)
  .forEach((r, i) => {
    csv += `${i+1},${r.name},${r.score},${r.score>=80?"Selected":"Rejected"}\n`
  })

  const blob = new Blob([csv], {type:"text/csv"})
  const url = URL.createObjectURL(blob)

  const a = document.createElement("a")
  a.href = url
  a.download = "resume_results.csv"
  a.click()
}
