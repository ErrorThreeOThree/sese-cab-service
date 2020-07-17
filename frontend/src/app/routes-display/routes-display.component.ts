import {Component, OnInit} from '@angular/core';
import {Route} from '../route';
import {BackendService} from '../backend.service';
import {RouteAction} from '../route-action';

@Component({
    selector: 'app-routes-display',
    templateUrl: './routes-display.component.html',
    styleUrls: ['./routes-display.component.css']
})
export class RoutesDisplayComponent implements OnInit {

    constructor(private backendService: BackendService) {
    }

    routes: Route[] = [];

    updateTable() {
        this.backendService.getRoutes().then(routes => {
            this.routes = [];
            routes.forEach(route => this.routes.push(route));
        });
    }

    routesAvailable() {
        return this.routes.length > 0;
    }

    jobIdsString(route: Route) {
        if (route.jobId === undefined) {
            return '-';
        }
        if (route.jobId2 === undefined) {
            return route.jobId;
        }
        return route.jobId + ', ' + route.jobId2;
    }

    routeActionsString(routeActions: RouteAction[]) {
        let routeString = '';
        for (let i = 0; i < routeActions.length; i++) {
            const action = routeActions[i];
            routeString += '[';
            if (action.marker < 10) {
                routeString += ' ';
            }
            routeString += action.marker + '] ';
            if (action.action === 'pickup') {
                routeString += '↑ 🧔 ' + action.customerId;
            } else if (action.action === 'dropoff') {
                routeString += '↓ 🧔 ' + action.customerId;
            } else if (action.action === 'turn') {
                if (action.direction === 'right') {
                    routeString += '→';
                }
                if (action.direction === 'left') {
                    routeString += '←';
                }
            } else if (action.action === 'wait') {
                routeString += '↻';
            }
            if (i < routeActions.length - 1) {
                routeString += '<br>';
            }
        }
        return routeString;
    }

    ngOnInit(): void {
        this.updateTable();
        setInterval(() => {
            this.updateTable();
        }, 1000);
    }

}
