jQuery(document).ready(function($) {
    function handleMessage(event) {
        if(event.data.facebook) {
            $.ajax({
                type: 'POST',
                url: handler_params.ajax_url,
                data: {
                    action: 'ampng_sharable_function',
                    data: event.data.facebook,
                    create: true,
                    desc: event.data.desc,
                    destination: "facebook",
                    security: handler_params.ampng_nonce
                },
                success: successFunction
            });
        }
        if(event.data.messenger) {
            $.ajax({
                type: 'POST',
                url: handler_params.ajax_url,
                data: {
                    action: 'ampng_sharable_function',
                    data: event.data.messenger,
                    create: true,
                    desc: event.data.desc,
                    destination: "messenger",
                    security: handler_params.ampng_nonce
                },
                success: successFunction
            });
        }
        if(event.data.linkedin) {
            $.ajax({
                type: 'POST',
                url: handler_params.ajax_url,
                data: {
                    action: 'ampng_sharable_function',
                    data: event.data.linkedin,
                    desc: event.data.desc,
                    destination: "linkedin",
                    security: handler_params.ampng_nonce
                },
                success: successFunction
            });
        }
        if(event.data.email) {
            $.ajax({
                type: 'POST',
                url: handler_params.ajax_url,
                data: {
                    action: 'ampng_sharable_function',
                    data: event.data.email,
                    desc: event.data.desc,
                    destination: "email",
                    security: handler_params.ampng_nonce
                },
                success: successFunction
            });
        }
        if(event.data.others) {
            $.ajax({
                type: 'POST',
                url: handler_params.ajax_url,
                data: {
                    action: 'ampng_sharable_function',
                    data: event.data.others,
                    desc: event.data.desc,
                    destination: "print",
                    security: handler_params.ampng_nonce
                },
                success: successFunction
            });
        }
    }

    window.addEventListener('message', handleMessage);

    function successFunction(response) {
        window.open(response, "_blank");
    }
});