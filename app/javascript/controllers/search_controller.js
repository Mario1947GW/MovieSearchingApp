import {Controller} from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
    static targets = ["title", "withGenres", "type", "year", "voteAverageMin", "firstActor", "secondActor"]

    connect() {
    }

    search() {
        const baseUrl = "/results?"
        const chosenOption = document.querySelector("input[name='title_or_filters']:checked")
        let queryParams
        if (chosenOption.value === "title" ) {
            queryParams = this.searchByTitle()
         }
         else{
             queryParams = this.searchByOtherFilters()
         }
        const location = baseUrl + new URLSearchParams(queryParams).toString();
        return window.location = location
    }

    searchByTitle() {
        const title = this.titleTarget.value
        let queryParams = {
            title: title.length > 0 ? title : null,
            page: 1}
        return Object.fromEntries(Object.entries(queryParams).filter(([_, v]) => v != null));
    }

    searchByOtherFilters() {
        const genresList = this.genres(this.withGenresTarget)
        const type = this.typeTarget.value
        const year = this.yearTarget.value
        const voteAverageMin = this.voteAverageMinTarget.value
        const firstActor = this.firstActorTarget.value
        const secondActor = this.secondActorTarget.value

        let queryParams = {
            with_genres: genresList.length > 0 ? genresList : null,
            type: type.length > 0 ? type : null,
            primary_release_year: year.length > 0 ? year : null,
            "vote_average.gte": voteAverageMin.length > 0 ? voteAverageMin : null,
            with_cast: (firstActor.length >= 3 || secondActor.length >= 3) ? `${firstActor},${secondActor}` : null,
            page: 1
        };
        return Object.fromEntries(Object.entries(queryParams).filter(([_, v]) => v != null));
    }

    genres(target) {
        let genresSelected = []
        const options = this.withGenresTarget.options
        for (let i = 0; i < options.length; i++) {
            const option = options[i]
            if (option.selected) {
                genresSelected.push(option.value)
            }
        }
        return genresSelected.join(',')
    }

    changeGenresList(event) {
        const genresSelect = this.withGenresTarget
        genresSelect.innerHTML = ''
        Rails.ajax({
            type: "GET",
            url: `/genres_list?type=${event.target.value}`,
            dataType: 'json',
            success: (data) => {
                console.log(data)
                data.forEach(genre => {
                    genresSelect.insertAdjacentHTML("beforeend", `<option value=${genre[0]}>${genre[1]}</option>`)
                })
            },
            error: () => {
                alert("There was an error")
            }
        })

    }

    validate(event) {
        let value = event.target.value
        event.target.value = value.replace(/[^A-Za-z ]/g, '');
    }

    filterForm(event) {
        if (event.target.value === "title") {
            [this.withGenresTarget, this.typeTarget, this.yearTarget, this.voteAverageMinTarget,
                this.voteAverageMinTarget, this.firstActorTarget, this.secondActorTarget].forEach(target => {
            target.parentElement.classList.add("hidden")
            })
            this.titleTarget.parentElement.classList.remove("hidden")
        } else {
            [this.withGenresTarget, this.typeTarget, this.yearTarget, this.voteAverageMinTarget,
                this.voteAverageMinTarget, this.firstActorTarget, this.secondActorTarget].forEach(target => {
                target.parentElement.classList.remove("hidden")
            })
            this.titleTarget.parentElement.classList.add("hidden")
        }

    }

}
