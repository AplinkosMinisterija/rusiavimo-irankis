<?php
/*
Plugin Name: Aplinkos Ministerijos - Norway Grants
Description: A plugin that helps users learn about waste management and disposal. Insert shortcode [aplinkos-ministerija] into website body.
Version: 1.0
Author: UAB THINKBIG LT
*/

if ( ! defined( 'ABSPATH' ) ) exit;

session_start();

function waste_management_shortcode() {
    // Define the waste categories and subcategories

    $homeUrl = plugins_url('rusiuok/index.html', __FILE__);
    $functionUrl = plugins_url('sharables/function.php', __FILE__);
    $nonce = wp_create_nonce('custom_nonce');
    $_SESSION['custom_nonce'] = $nonce;
    $_SESSION['allow_entrance'] = 'Allowed';

    // Generate the HTML for the waste management tool
    $html = '
        <div id="iframe-holder"></div><div id="container"><iframe title="Rušiavimo įrankis" scrolling="no" id="my-iframe" class="responsive-iframe" src="'.$homeUrl.'?t='.time().'" width="100%" frameborder="0" style="overflow: none"></iframe></div>
        <iframe title="Rušiavimo įrankis" id="static-iframe" src="'.$homeUrl.'" width="100%" height="10px" frameborder="0" style="overflow: none"></iframe>
    ';

        $html .= '<script>
        const sharableScript = "'.$functionUrl.'";
        const another = document.getElementById("static-iframe");
        const childWindow = document.getElementById("my-iframe").contentWindow;
        var iframe = document.getElementById("my-iframe");
        if(another.contentWindow.document.body.scrollHeight != 10) {
          iframe.remove();

                            window.addEventListener("message", message => {
                              if (message.target[0] !== childWindow) {
                                  return; // Skip message in this event listener
                              }

                            if(message.data.goUp) {
                                window.scrollTo(0, 0);
                            }

                            // facebook
                            if(message.data.facebook) {
                                var xhr = new XMLHttpRequest();
                                xhr.open("POST", sharableScript, true);
                                xhr.send(JSON.stringify({ 
                                    data: message.data.facebook, 
                                    create: true, 
                                    desc: message.data.desc,
                                    destination: "facebook",
                                    nonce: "'.$nonce.'"
                                }
                                ));
                                xhr.onload = function() {
                                    if(xhr.readyState == 4 && xhr.status == 200) {
                                        window.open(xhr.responseText, "_blank");
                                    }
                                }
                            }

                            // messenger
                            if(message.data.messenger) {
                                var xhr = new XMLHttpRequest();
                                xhr.open("POST", sharableScript, true);
                                xhr.send(JSON.stringify({ 
                                    data: message.data.messenger, 
                                    create: true, 
                                    desc: message.data.desc,
                                    destination: "messenger",
                                    nonce: "'.$nonce.'"
                                }
                                ));
                                xhr.onload = function() {
                                    if(xhr.readyState == 4 && xhr.status == 200) {
                                        window.open(xhr.responseText, "_blank");
                                    }
                                }
                            }

                            // linkedin
                            if(message.data.linkedin) {
                                var xhr = new XMLHttpRequest();
                                xhr.open("POST", sharableScript, true);
                                xhr.send(JSON.stringify({ 
                                    data: message.data.linkedin, 
                                    desc: message.data.desc,
                                    destination: "linkedin",
                                    nonce: "'.$nonce.'"
                                }
                                ));
                                xhr.onload = function() {
                                    if(xhr.readyState == 4 && xhr.status == 200) {
                                        window.open(xhr.responseText, "_blank");
                                    }
                                }
                            }

                            // email
                            if(message.data.email) {
                                var xhr = new XMLHttpRequest();
                                xhr.open("POST", sharableScript, true);
                                xhr.send(JSON.stringify({ 
                                    data: message.data.email, 
                                    desc: message.data.desc,
                                    destination: "email",
                                    nonce: "'.$nonce.'"
                                }
                                ));
                                xhr.onload = function() {
                                    if(xhr.readyState == 4 && xhr.status == 200) {
                                        window.open(xhr.responseText, "_blank");
                                    }
                                }
                            }

                            // print
                            if(message.data.others) {
                                var xhr = new XMLHttpRequest();
                                xhr.open("POST", sharableScript, true);
                                xhr.send(JSON.stringify({ 
                                    data: message.data.others, 
                                    desc: message.data.desc,
                                    destination: "print",
                                    nonce: "'.$nonce.'"
                                }
                                ));
                                xhr.onload = function() {
                                    if(xhr.readyState == 4 && xhr.status == 200) {
                                        window.open(xhr.responseText, "_blank");
                                    }
                                }
                            }

                          });

        } else {
        another.remove();
        setTimeout(function() {
            iframe.contentWindow.postMessage("notStatic", "*");
        }, 5000);

        document.addEventListener("touchmove", function(e) {
            var iframe = document.querySelector("iframe");
            var iframeRect = iframe.getBoundingClientRect();
            var touch = e.touches[0];

        if (touch.clientX > iframeRect.left && touch.clientX < iframeRect.right &&
            touch.clientY > iframeRect.top && touch.clientY < iframeRect.bottom) {
                }
                    });
        window.setInterval(function(){
            var el = document.activeElement;
        }, 1000);

            window.addEventListener("message", message => {
                              if (message.target[0] !== childWindow) {
                                  return; // Skip message in this event listener
                              }

                            if(message.data.goUp) {
                                window.scrollTo(0, 0);
                            }

                              iframe.style.height = event.data.height + "px";

                            // facebook
                            if(message.data.facebook) {
                                var xhr = new XMLHttpRequest();
                                xhr.open("POST", sharableScript, true);
                                xhr.send(JSON.stringify({ 
                                    data: message.data.facebook, 
                                    create: true, 
                                    desc: message.data.desc,
                                    destination: "facebook",
                                    nonce: "'.$nonce.'"
                                }
                                ));
                                xhr.onload = function() {
                                    if(xhr.readyState == 4 && xhr.status == 200) {
                                        window.open(xhr.responseText, "_blank");
                                    }
                                }
                            }

                            // messenger
                            if(message.data.messenger) {
                                var xhr = new XMLHttpRequest();
                                xhr.open("POST", sharableScript, true);
                                xhr.send(JSON.stringify({ 
                                    data: message.data.messenger, 
                                    create: true, 
                                    desc: message.data.desc,
                                    destination: "messenger",
                                    nonce: "'.$nonce.'"
                                }
                                ));
                                xhr.onload = function() {
                                    if(xhr.readyState == 4 && xhr.status == 200) {
                                        window.open(xhr.responseText, "_blank");
                                    }
                                }
                            }

                            // linkedin
                            if(message.data.linkedin) {
                                var xhr = new XMLHttpRequest();
                                xhr.open("POST", sharableScript, true);
                                xhr.send(JSON.stringify({ 
                                    data: message.data.linkedin, 
                                    desc: message.data.desc,
                                    destination: "linkedin",
                                    nonce: "'.$nonce.'"
                                }
                                ));
                                xhr.onload = function() {
                                    if(xhr.readyState == 4 && xhr.status == 200) {
                                        window.open(xhr.responseText, "_blank");
                                    }
                                }
                            }

                            // email
                            if(message.data.email) {
                                var xhr = new XMLHttpRequest();
                                xhr.open("POST", sharableScript, true);
                                xhr.send(JSON.stringify({ 
                                    data: message.data.email, 
                                    desc: message.data.desc,
                                    destination: "email",
                                    nonce: "'.$nonce.'"
                                }
                                ));
                                xhr.onload = function() {
                                    if(xhr.readyState == 4 && xhr.status == 200) {
                                        window.open(xhr.responseText, "_blank");
                                    }
                                }
                            }

                            // print
                            if(message.data.others) {
                                var xhr = new XMLHttpRequest();
                                xhr.open("POST", sharableScript, true);
                                xhr.send(JSON.stringify({ 
                                    data: message.data.others, 
                                    desc: message.data.desc,
                                    destination: "print",
                                    nonce: "'.$nonce.'"
                                }
                                ));
                                xhr.onload = function() {
                                    if(xhr.readyState == 4 && xhr.status == 200) {
                                        window.open(xhr.responseText, "_blank");
                                    }
                                }
                            }

                          });

        }

                          </script>';
    // Return the HTML
    return $html;
}
add_shortcode('aplinkos-ministerija', 'waste_management_shortcode');