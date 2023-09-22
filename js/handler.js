jQuery(document).ready(function($) {
    function handleMessage(event) {
        if(event.data.facebook) {
            $.ajax({
                type: 'POST',
                url: handler_params.ajax_url,
                data: {
                    action: 'amp_sharable_function',
                    data: event.data.facebook,
                    create: true,
                    desc: event.data.desc,
                    destination: "facebook"
                },
                success: successFunction
            });
        }
        if(event.data.messenger) {
            $.ajax({
                type: 'POST',
                url: handler_params.ajax_url,
                data: {
                    action: 'amp_sharable_function',
                    data: event.data.messenger,
                    create: true,
                    desc: event.data.desc,
                    destination: "messenger"
                },
                success: successFunction
            });
        }
        if(event.data.linkedin) {
            $.ajax({
                type: 'POST',
                url: handler_params.ajax_url,
                data: {
                    action: 'amp_sharable_function',
                    data: event.data.linkedin,
                    desc: event.data.desc,
                    destination: "linkedin"
                },
                success: successFunction
            });
        }
        if(event.data.email) {
            $.ajax({
                type: 'POST',
                url: handler_params.ajax_url,
                data: {
                    action: 'amp_sharable_function',
                    data: event.data.email,
                    desc: event.data.desc,
                    destination: "email"
                },
                success: successFunction
            });
        }
        if(event.data.others) {
            $.ajax({
                type: 'POST',
                url: handler_params.ajax_url,
                data: {
                    action: 'amp_sharable_function',
                    data: event.data.others,
                    desc: event.data.desc,
                    destination: "print"
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