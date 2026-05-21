// ================= INDEX PAGE =================

const fileInput = document.getElementById("fileInput")
const dropzone = document.getElementById("dropzone")
const fileTags = document.getElementById("fileTags")
const analyzeBtn = document.getElementById("analyzeBtn")

let filesArray = []

if (dropzone && fileInput) {

  // FIX 1: Prevent click bubbling loops
  dropzone.addEventListener("click", (e) => {
    if (e.target !== fileInput) {
      fileInput.click()
    }
  })

  // FIX 2: Clear input value cache so it updates instantly on the 1st try
  fileInput.addEventListener("change", () => {
    const newFiles = Array.from(fileInput.files)
    newFiles.forEach(file => {
      if (!filesArray.some(f => f.name === file.name)) {
        filesArray.push(file)
      }
    })
    renderTags()
    fileInput.value = "" // Clears the selection cache
  })

  dropzone.addEventListener("dragover", (e) => {
    e.preventDefault()
    dropzone.style.background = "rgba(59,130,246,0.2)"
  })

  dropzone.addEventListener("dragleave", () => {
    dropzone.style.background = "transparent"
  })

  dropzone.addEventListener("drop", (e) => {
    e.preventDefault()
    dropzone.style.background = "transparent"
    const newFiles = Array.from(e.dataTransfer.files)
    newFiles.forEach(file => {
      if (!filesArray.some(f => f.name === file.name)) {
        filesArray.push(file)
      }
    })
    renderTags()
  })

  analyzeBtn.addEventListener("click", async () => {
    const jobDesc = document.getElementById("jobDesc").value;

    if (filesArray.length === 0) {
      alert("Please upload resumes first.");
      return;
    }
    if (!jobDesc.trim()) {
      alert("Please enter a job description or keywords.");
      return;
    }

    // Temporary non-breaking loading element
    const loadingMsg = document.createElement("p");
    loadingMsg.id = "apiLoadingMsg";
    loadingMsg.style = 'text-align:center; position:fixed; top:50%; width:100%; color:white; z-index:999; background:rgba(0,0,0,0.8); padding:20px;';
    loadingMsg.innerText = "Calling AI Engine... Please wait";
    document.body.appendChild(loadingMsg);

    const results = [];

    for (let i = 0; i < filesArray.length; i++) {
      const file = filesArray[i];
      const formData = new FormData();
      formData.append("resume_file", file);
      formData.append("job_description", jobDesc);

      try {
        const response = await fetch("http://localhost:8000/api/screen-resume/", {
          method: "POST",
          body: formData
        });

        if (!response.ok) {
           console.error(`Failed to process ${file.name}`);
           continue;
        }

        const data = await response.json();
        
        results.push({
          name: data.filename,
          score: Math.round(data.match_score_percentage) 
        });

      } catch (error) {
        console.error("Error connecting to API:", error);
      }
    }

    const oldMsg = document.getElementById("apiLoadingMsg");
    if(oldMsg) oldMsg.remove();

    localStorage.setItem("resumes", JSON.stringify(results));
    window.location.href = "result.html";

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

  if (!list) return

  const data = JSON.parse(localStorage.getItem("resumes")) || []

  if (data.length === 0) {
    if (loading) loading.innerText = "No resumes found. Please go back and upload some!"
    return
  }

  resumesGlobal = data;
  render(resumesGlobal);
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