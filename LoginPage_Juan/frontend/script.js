// THe tabs
const tabLogin = document.getElementById("tab-login");
const tabSignup = document.getElementById("tab-signup");

const headerText = document.getElementById("header-text");
const subheaderText = document.getElementById("subheader-text");
const mainButton = document.getElementById("main-button");
const mainForm = document.getElementById("main-form");

let mode = "login"; // login OR signup

// swiching the modes from loginto signup
tabLogin.addEventListener("click", () => 
  {
  mode = "login";
  tabLogin.classList.add("active");
  tabSignup.classList.remove("active");

  headerText.innerText = "Sign in to your account";
  subheaderText.innerText = "Enter your email and password";
  mainButton.innerText = "Sign In";
});

tabSignup.addEventListener("click", () => 
  {
  mode = "signup";
  tabSignup.classList.add("active");
  tabLogin.classList.remove("active");

  headerText.innerText = "Create a new account";
  subheaderText.innerText = "Enter your email and password";
  mainButton.innerText = "Create Account";
});

// submitting the form
mainForm.addEventListener("submit", async (e) => 
  {
  e.preventDefault();

  const email = document.getElementById("main-email").value.trim();
  const password = document.getElementById("main-password").value.trim();

  const endpoint = mode === "login" ? "/login" : "/signup";

  const res = await fetch(`http://127.0.0.1:5000${endpoint}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });

  const data = await res.json();
  alert(data.message);
});

const forgotBtn = document.getElementById("forgot");
const resetSection = document.getElementById("reset-section");
const resetBtn = document.getElementById("reset-btn");
const popup = document.getElementById("popup");
const submitNewPassword = document.getElementById("submit-new-password");

forgotBtn.addEventListener("click", () => 
  {
  resetSection.classList.toggle("hidden");
});

// checking the email
resetBtn.addEventListener("click", async () => 
  {
  const email = document.getElementById("reset-email").value.trim();
  if (!email) return alert("Enter your email.");

  const res = await fetch("http://127.0.0.1:5000/check-email", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email })
  });

  const data = await res.json();
  if (!data.exists) return alert("Email not found.");

  popup.dataset.email = email;
  popup.classList.remove("hidden");
});

// entering the NEW PASSWORD
submitNewPassword.addEventListener("click", async () => 
  {
  const email = popup.dataset.email;
  const newPassword = document.getElementById("new-password").value.trim();

  const res = await fetch("http://127.0.0.1:5000/reset", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, new_password: newPassword })
  });

  alert((await res.json()).message);
  popup.classList.add("hidden");
});


//showing and hiding password
document.querySelectorAll(".toggle-password").forEach(icon => 
  {
  icon.addEventListener("click", () => {
    const targetId = icon.getAttribute("data-target");
    const input = document.getElementById(targetId);

    if (input.type === "password") {
      input.type = "text";
      icon.textContent = "👁️‍🗨️"; //hiding the password
    } else {
      input.type = "password";
      icon.textContent = "👁"; // showing the password
    }
  });
});

