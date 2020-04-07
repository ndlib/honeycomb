var React = require('react');
var PeopleSearch = React.createClass({
    getInitialState: function() {
        return { peopleList: [],
            activePersonId: null,
            currentSearch: null,
            lastSearch: null,
        }
    },
    updateSearchValue: function(searchValue) {
        this.setState({
            currentSearch: searchValue,
            activePersonId: null,
        });
    },
    loadPeopleFromServer: function() {
        var searchValue = this.state.currentSearch;
        if (searchValue && !this.state.activePersonId && searchValue != this.state.lastSearch) {
            var searchUrl = this.props.searchUrl + '?q=' + encodeURIComponent(searchValue);
            $.ajax({
                url: searchUrl,
                dataType: "json",
                success: (function(data) {
                    this.setState({
                        peopleList: data,
                        lastSearch: searchValue
                    });
                }).bind(this),
                error: (function(xhr, status, err) {
                    console.error(searchUrl, status, err.toString());
                }).bind(this)
            });
        }
    },
    setActivePerson: function(person) {
        var id = null;
        var search = null;
        if (person) {
            id = person.id;
            search = person.label;
        }
        this.setState({
            activePersonId: id,
            currentSearch: search,
            peopleList: []
        });
    },
    selectActivePerson: function() {
        if (this.props.selectPerson) {
            this.props.selectPerson(this.state.activePersonId);
        }
        this.setActivePerson(null);
    },
    componentWillMount: function() {
        this.debouncedLoadPeople = _.debounce(function(event) {
            this.loadPeopleFromServer();
        }.bind(this), 100);
    },
    componentDidUpdate: function(prevProps, prevState) {
        if (this.state.currentSearch && this.state.currentSearch != prevState.currentSearch) {
            this.debouncedLoadPeople();
        }
    },
    render: function() {
        var hideList = !this.state.currentSearch || this.state.activePersonId;
        return (
            <div>
                <div className="people_list" >
                    <PeopleSearchForm
                        invokeSearch={this.updateSearchValue}
                        selectPerson={this.selectActivePerson}
                        currentValue={this.state.currentSearch}
                        setActivePerson={this.setActivePerson}
                        activePersonId={this.state.activePersonId} />
                    <i>* For best results, search using netid.</i>
                    <PeopleSearchList
                        people={this.state.peopleList}
                        setActivePerson={this.setActivePerson}
                        hide={hideList} />
                </div>
            </div>
        );
    }
});
module.exports = PeopleSearch;
