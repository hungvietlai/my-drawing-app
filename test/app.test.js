// app.test.js
const fs = require('fs');
const path = require('path');
const jsdom = require('jsdom');
const { JSDOM } = jsdom;

const html = fs.readFileSync(path.resolve(__dirname, '../public/index.html'), 'utf8');

describe('index.html', () => {
    let dom;
    let container;

    beforeEach(() => {
        dom = new JSDOM(html, { runScripts: 'dangerously' });
        container = dom.window.document.body;
    });

    it('Canvas should be present', () => {
        expect(container.querySelector('#drawingCanvas')).not.toBeNull();
    });

    // Add more tests here as needed
});
