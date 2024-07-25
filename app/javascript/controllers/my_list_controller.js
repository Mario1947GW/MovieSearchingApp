import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";
export default class extends Controller {
    static targets = [ "id", "type", "icon"]
    connect() {
    }

    addToMyList() {
        const id = this.idTarget.value
        const type = this.typeTarget.value
        this.sendRequest(`/add_item_to_my_list?id=${id}&type=${type}`, "POST", "removeFromMyList")
    }

    removeFromMyList() {
        const id = this.idTarget.value
        const type = this.typeTarget.value
        this.sendRequest(`/remove_item_from_my_list?id=${id}&type=${type}`, "DELETE", "addToMyList")
    }
    sendRequest(url, method, action) {
        const icon = this.iconTarget
        console.log(icon)
        Rails.ajax( {
            type: method,
            url: url,
            dataType: 'json',
            success: (data)=> {
                console.log(data)
                if ( icon.classList.contains("fa-regular")) {
                    icon.classList.replace("fa-regular", "fa-solid")
                }
                else{
                    icon.classList.replace("fa-solid", "fa-regular")
                }
                icon.setAttribute("data-action", `click->my-list#${action}`)
            },
            error: () =>{
                alert("There was an error")
            }
        })
    }


}
