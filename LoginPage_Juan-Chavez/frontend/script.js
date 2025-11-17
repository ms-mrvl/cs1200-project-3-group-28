// tabs
let loginTab = document.getElementById("tab-login");
let signupTab = document.getElementById("tab-signup");
let headerTxt = document.getElementById("header-text");
let subTxt = document.getElementById("subheader-text");
let mainBtn = document.getElementById("main-button");
let mainForm = document.getElementById("main-form");

let mode = "login";

// popups
let resetPopup = document.getElementById("popup");
let msgPopup = document.getElementById("msg-popup");
let msgText = document.getElementById("msg-text");
let msgClose = document.getElementById("msg-close");

// check if ANY popup is open and to hide them
function popupOpen()
{
    return !resetPopup.classList.contains("hidden") ||
           !msgPopup.classList.contains("hidden");
}

// show message inside phone
function showMsg(text)
{
    msgText.innerText = text;
    msgPopup.classList.remove("hidden");
}

msgClose.onclick = function()
{
    msgPopup.classList.add("hidden");
}


// tab switching
loginTab.onclick = function() 
{
  mode = "login";
  loginTab.classList.add("active");
  signupTab.classList.remove("active");

  headerTxt.innerText = "Sign in to your account";
  subTxt.innerText = "Enter your email and password";
  mainBtn.innerText = "Sign In";
}

signupTab.onclick = function() 
{
  mode = "signup";
  signupTab.classList.add("active");
  loginTab.classList.remove("active");

  headerTxt.innerText = "Create a new account";
  subTxt.innerText = "Enter your email and password";
  mainBtn.innerText = "Create Account";
}


// submit
mainForm.addEventListener("submit", async function(e)
{
    if (popupOpen())
    {
        e.preventDefault();
        return;
    }

    e.preventDefault();

    let email = document.getElementById("main-email").value;
    let pass = document.getElementById("main-password").value;

    let link = "/login";
    if (mode === "signup") 
    {
        link = "/signup";
    }

    let resp = await fetch("http://127.0.0.1:5000" + link, 
    {
        method: "POST",
        headers: { "Content-Type":"application/json"},
        body: JSON.stringify({ email: email.trim(), password: pass.trim() })
    });

    let data = await resp.json();
    showMsg(data.message);


})


// forgot password
let forgotBtn = document.getElementById("forgot");
let resetSec = document.getElementById("reset-section");
let resetBtn = document.getElementById("reset-btn");
let newPwBtn = document.getElementById("submit-new-password");

forgotBtn.onclick = function() 
{
    if (resetSec.classList.contains("hidden")) 
    {
        resetSec.classList.remove("hidden");
    } 
    else 
    {
        resetSec.classList.add("hidden");
    }
}

resetBtn.onclick = async function() 
{
    let em = document.getElementById("reset-email").value;
    if (em.trim() === "") 
    {
        showMsg("Enter your email.");
        return;
    }

    let res = await fetch("http://127.0.0.1:5000/check-email", 
    {
        method: "POST",
        headers: {"Content-Type":"application/json"},
        body: JSON.stringify({ email: em })
    });

    let out = await res.json();

    if (!out.exists) 
    {
        showMsg("Email not found.");
        return;
    }

    resetPopup.dataset.email = em;
    resetPopup.classList.remove("hidden");
}


// actually reset
newPwBtn.onclick = async function() 
{
    let savedEmail = resetPopup.dataset.email;
    let newPw = document.getElementById("new-password").value;

    let res = await fetch("http://127.0.0.1:5000/reset", 
    {
        method:"POST",
        headers: {"Content-Type":"application/json"},
        body: JSON.stringify({ email: savedEmail, new_password: newPw })
    })

    let out = await res.json();
    showMsg(out.message);

    resetPopup.classList.add("hidden");
}


// toggle pw icons
let toggles = document.querySelectorAll(".toggle-password");

for (let i = 0; i < toggles.length; i++) 
{
    toggles[i].onclick = function() 
    {
        let id = toggles[i].getAttribute("data-target");
        let input = document.getElementById(id);
        if (input.type === "password") 
        {
            input.type = "text";
            toggles[i].textContent = "👁️‍🗨️";
        } 
        else 
        {
            input.type = "password";
            toggles[i].textContent = "👁";
        }
    }
}

