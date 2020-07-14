import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Job} from './job';
import {Pickup} from './pickup';
import {Dropoff} from './dropoff';
import {Route} from './route';
import {Cab} from './cab';
import {Sensor} from './sensor';
import {BackendCabSensorStatus} from './backend-cab-sensor-status';

@Injectable({
  providedIn: 'root'
})
export class BackendService {

  constructor(private http: HttpClient) {
  }

  developmentMode = true;

  host = this.developmentMode ? 'localhost' : '167.71.35.10';
  port = 8081;

  saveJob(job: Job) {
    return this.http.post('http://' + this.host + ':' + this.port + '/api/bookr/job', job).toPromise();
  }

  deleteJob(id: number) {
    return this.http.delete('http://' + this.host + ':' + this.port + '/api/bookr/job', {
      params: {
        id: id.toString()
      }
    }).toPromise();
  }

  getJobs() {
    return this.http.get('http://' + this.host + ':' + this.port + '/api/bookr/jobs').toPromise() as Promise<Job[]>;
  }

  getPickups() {
    return this.http.get('http://' + this.host + ':' + this.port + '/api/bookr/pickupRequests').toPromise() as Promise<Pickup[]>;
  }

  acceptPickup(customerId: number) {
    return this.http.post('http://' + this.host + ':' + this.port + '/api/bookr/acceptPickup?customerId=' + customerId, {}).toPromise();
  }

  getDropoffs() {
    return this.http.get('http://' + this.host + ':' + this.port + '/api/bookr/dropoffRequests').toPromise() as Promise<Dropoff[]>;
  }

  acceptDropoff(customerId: number) {
    return this.http.post('http://' + this.host + ':' + this.port + '/api/bookr/acceptDropoff?customerId=' + customerId, {})
        .toPromise();
  }

  getRoutes() {
    return this.http.get('http://' + this.host + ':' + this.port + '/api/bookr/getRoutes').toPromise() as Promise<Route[]>;
  }

  getRegisteredCabs() {
    return this.http.get('http://' + this.host + ':' + this.port + '/api/bookr/registeredCabs').toPromise() as Promise<Cab[]>;
  }

  saveSensorData(cabId: number, sensor: Sensor) {
    this.http.post('http://' + this.host + ':' + this.port + '/api/bookr/setSensorStatus' +
        '?cabId=' + cabId + '&sensorName=' + sensor.name +
        '&disabled=' + !sensor.active + '&noise=' + sensor.noise, {})
        .toPromise();
  }

  getSensorData(cabId: number) {
    return this.http.get('http://' + this.host + ':' + this.port + '/api/ec/sensorStatus?cabId=' + cabId, {})
        .toPromise() as Promise<BackendCabSensorStatus>;
  }

  softResetBackend() {
    this.http.post('http://' + this.host + ':' + this.port + '/api/bookr/softResetBackend', {}).toPromise();
  }

  hardResetBackend() {
    this.http.post('http://' + this.host + ':' + this.port + '/api/bookr/hardResetBackend', {}).toPromise();
  }
}
