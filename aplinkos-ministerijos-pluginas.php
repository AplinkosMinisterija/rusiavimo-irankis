<?php
/*
Plugin Name: Aplinkos Ministerijos - Norway Grants
Description: A plugin that helps users learn about waste management and disposal. Insert shortcode [aplinkos-ministerija] into website body.
Version: 1.0
Author: UAB THINKBIG LT
*/

function waste_management_shortcode() {
    // Define the waste categories and subcategories

    // Generate the HTML for the waste management tool
    $html = '<div id="iframe-holder"></div><div id="container"><iframe scrolling="no" id="my-iframe" class="responsive-iframe" src="/wp-content/plugins/aplinkos-ministerijos-pluginas/rusiuok/index.html?t='.time().'" width="100%" frameborder="0" style="overflow: none"></iframe></div>';

        $html .= '<script>
        const childWindow = document.getElementById("my-iframe").contentWindow;
                              var iframe = document.getElementById("my-iframe");
                          window.addEventListener("message", message => {
                              if (message.target[0] !== childWindow) {
                                  return; // Skip message in this event listener
                              }
                              iframe.style.height = event.data.height + "px";

                            // facebook
                            if(message.data.facebook) {
                                $.post("/wp-content/plugins/aplinkos-ministerijos-pluginas/sharables/function.php", { data: message.data.facebook }, function(result) {
                                    window.open("https://www.facebook.com/sharer/sharer.php?u=https://" + result, "_blank");
                                });
                            }

                            // messenger
                            if(message.data.messenger) {
                                $.post("/wp-content/plugins/aplinkos-ministerijos-pluginas/sharables/function.php", { data: message.data.messenger }, function(result) {
                                    var link = document.createElement("a");
                                    link.href = "https://www.addtoany.com/add_to/facebook_messenger?linkurl=" + result;
<!--                                     link.href = "fb-messenger://share/?link=https://" + result; -->
                                    link.target = "_blank";
                                    link.click();
                                });
                            }

                            // linkedin
                            if(message.data.linkedin) {
                                $.post("/wp-content/plugins/aplinkos-ministerijos-pluginas/sharables/function.php", { data: message.data.linkedin }, function(result) {
                                    var link = document.createElement("a");
                                    link.href = "https://www.linkedin.com/sharing/share-offsite/?url=https://" + result;
                                    link.target = "_blank";
                                    link.click();
                                });
                            }

                            // email
                            if(message.data.email) {
                                $.post("/wp-content/plugins/aplinkos-ministerijos-pluginas/sharables/function.php", { data: message.data.email }, function(result) {
                                    var mail = document.createElement("a");
                                    mail.href = "https://www.addtoany.com/add_to/email?linkurl=" + result;
                                    mail.click();
                                });
                            }

                            // print
                            if(message.data.others) {
                                $.post("/wp-content/plugins/aplinkos-ministerijos-pluginas/sharables/function.php", { data: message.data.others }, function(result) {
                                    var link = document.createElement("a");
                                    link.href = "https://" + result;
                                    link.target = "_blank";
                                    link.click();
                                });
                            }

                          });

                          document.addEventListener("touchmove", function(e) {
                            var iframe = document.querySelector("iframe");
                            var iframeRect = iframe.getBoundingClientRect();
                            var touch = e.touches[0];

                            if (touch.clientX > iframeRect.left && touch.clientX < iframeRect.right &&
                                touch.clientY > iframeRect.top && touch.clientY < iframeRect.bottom) {
                              // User is scrolling over the iframe
                              // console.log("User is scrolling over the iframe");
                            }
                          });
                          window.setInterval(function(){
                              var el = document.activeElement;
                              // console.log(el.tagName);
                              //  console.log(window.innerHeight);
                          }, 1000);

                          </script>';
    // Return the HTML
    return $html;
}
add_shortcode('aplinkos-ministerija', 'waste_management_shortcode');